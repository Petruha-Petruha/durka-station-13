SUBSYSTEM_DEF(dbcore)
	name = "Database"
	flags = SS_BACKGROUND
	wait = 1 MINUTES
	init_order = SS_INIT_DBCORE

	/// Is the DB schema valid
	var/schema_valid = TRUE
	/// Timeout of failed connections
	var/failed_connection_timeout = 0
	/// Amount of failed connections
	var/failed_connections = 0

	/// Last error to occur
	var/last_error
	/// List of currenty processing queries
	var/list/active_queries = list()

	/// SQL errors that have occured mid round
	var/total_errors = 0

	/// Connection handle. This is an arbitrary handle returned from rust_g.
	var/connection

/datum/controller/subsystem/dbcore/stat_entry()
	..("A: [LAZYLEN(active_queries)]")

// This is in Initialize() so that its actually seen in chat
/datum/controller/subsystem/dbcore/Initialize()
	if(!schema_valid)
		to_chat(world, SPAN_BOLDANNOUNCE("Database schema ([db_version]) doesn't match the latest schema version ([DB_VERSION]). Roundstart has been delayed."))

	return ..()

/datum/controller/subsystem/dbcore/fire()
	for(var/I in active_queries)
		var/datum/db_query/Q = I
		if(world.time - Q.last_activity_time > 5 MINUTES)
			log_debug("Found undeleted query, please check the server logs and notify coders.")
			log_sql("Undeleted query: \"[Q.sql]\" LA: [Q.last_activity] LAT: [Q.last_activity_time]")
			qdel(Q)
		if(MC_TICK_CHECK)
			return

// Make sensitive variables immutable and invisible for VV
/datum/controller/subsystem/dbcore/may_edit_var(var/user, var/var_to_edit)
	if(var_to_edit == NAMEOF(src, connection))
		return FALSE
	if(var_to_edit == NAMEOF(src, active_queries))
		return FALSE
	. = ..()

/datum/controller/subsystem/dbcore/VV_hidden()
	return ..() + list(NAMEOF(src, connection), NAMEOF(src, active_queries))

/datum/controller/subsystem/dbcore/Recover()
	connection = SSdbcore.connection

/**
  * Connection Creator
  *
  * This proc basically does a few sanity checks before connecting, then attempts to make a connection
  * When connecting, RUST_G will initialize a thread pool for queries to use to run asynchronously
  */
/datum/controller/subsystem/dbcore/proc/Connect()
	if(IsConnected())
		return TRUE

	if(!sqlenabled)
		return FALSE

	if(failed_connection_timeout <= world.time) //it's been more than 5 seconds since we failed to connect, reset the counter
		failed_connections = 0

	if(failed_connections > 5)	//If it failed to establish a connection more than 5 times in a row, don't bother attempting to connect for 5 seconds.
		failed_connection_timeout = world.time + 50
		return FALSE

	var/result = json_decode(rustg_sql_connect_pool(json_encode(list(
		"host" = sqladdress,
		"port" = text2num(sqlport),
		"user" = sqlfdbklogin,
		"pass" = sqlfdbkpass,
		"db_name" = sqlfdbkdb,
		"read_timeout" = config.async_sql_query_timeout,
		"write_timeout" = config.async_sql_query_timeout,
		"max_threads" = config.rust_sql_thread_limit,

	))))
	. = (result["status"] == "ok")
	if(.)
		connection = result["handle"]
	else
		connection = null
		last_error = result["data"]
		log_sql("Connect() failed | [last_error]")
		++failed_connections

/**
  * Schema Version Checker
  *
  * Basically verifies that the DB schema in the config is the same as the version the game is expecting.
  * If it is a valid version, the DB will then connect.
  */
/datum/controller/subsystem/dbcore/proc/CheckSchemaVersion()
	if(sqlenabled)
		if(sqlenabled && db_version != DB_VERSION)
			sqlenabled = FALSE
			schema_valid = FALSE
			SSticker.delay_end = FALSE
			SEND_TEXT(world.log, "Database connection failed: Invalid SQL Versions")
			return FALSE
		if(Connect())
			SEND_TEXT(world.log, "Database connection established")
		else
			// log_sql() because then an error will be logged in the same place
			log_sql("Your server failed to establish a connection with the database")
	else
		SEND_TEXT(world.log, "Database is not enabled in configuration")

/**
  * Disconnection Handler
  *
  * Tells the DLL to clean up any open connections.
  * This will also reset the failed connection counter
  */
/datum/controller/subsystem/dbcore/proc/Disconnect()
	failed_connections = 0
	if(connection)
		rustg_sql_disconnect_pool(connection)
	connection = null

/**
  * Shutdown Handler
  *
  * Called during world/Reboot() as part of the MC shutdown
  * Finalises a round in the DB before disconnecting.
  */
/datum/controller/subsystem/dbcore/Shutdown()
	if(IsConnected())
		Disconnect()

/**
  * IsConnected Helper
  *
  * Short helper to check if the DB is connected or not.
  * Does a few sanity checks, then asks the DLL if we are properly connected
  */
/datum/controller/subsystem/dbcore/proc/IsConnected()
	if(!sqlenabled)
		return FALSE
	if(!schema_valid)
		return FALSE
	if(!connection)
		return FALSE
	return json_decode(rustg_sql_connected(connection))["status"] == "online"


/**
  * Error Message Helper
  *
  * Returns the last error that the subsystem encountered.
  * Will always report "Database disabled by configuration" if the DB is disabled.
  */
/datum/controller/subsystem/dbcore/proc/ErrorMsg()
	if(!sqlenabled)
		return "Database disabled by configuration"
	return last_error

/**
  * Error Reporting Helper
  *
  * Pretty much just sets `last_error` to the error argument
  *
  * Arguments:
  * * error - Error text to set `last_error` to
  */
/datum/controller/subsystem/dbcore/proc/ReportError(error)
	last_error = error


/**
  * New Query Invoker
  *
  * Checks to make sure this query isnt being invoked by admin fuckery, then returns a new [/datum/db_query]
  *
  * Arguments:
  * * sql_query - SQL query to be ran, with :parameter placeholders
  * * arguments - Associative list of parameters to be inserted into the query
  */
/datum/controller/subsystem/dbcore/proc/NewQuery(sql_query, arguments)
	return new /datum/db_query(connection, sql_query, arguments)

/**
  * Handler to allow many queries to be executed en masse
  *
  * Feed this proc a list of queries and it will execute them all at once, by the power of async magic!
  *
  * Arguments:
  * * querys - List of queries to execute
  * * warn - Boolean to warn on query failure
  * * qdel - Boolean to enable auto qdel of queries
  * * assoc - Boolean to enable support for an associative list of queries
  * * log - Do we want to generate logs for these queries
  */
/datum/controller/subsystem/dbcore/proc/MassExecute(list/querys, warn = FALSE, qdel = FALSE, assoc = FALSE, log = TRUE)
	if(!islist(querys))
		if(!istype(querys, /datum/db_query))
			CRASH("Invalid query passed to MassExecute: [querys]")
		querys = list(querys)

	var/start_time = start_watch()
	if(log)
		log_debug("Mass executing [LAZYLEN(querys)] queries...")

	for(var/thing in querys)
		var/datum/db_query/query
		if(assoc)
			query = querys[thing]
		else
			query = thing
		if(warn)
			INVOKE_ASYNC(query, /datum/db_query.proc/warn_execute)
		else
			INVOKE_ASYNC(query, /datum/db_query.proc/Execute)

	for(var/thing in querys)
		var/datum/db_query/query
		if(assoc)
			query = querys[thing]
		else
			query = thing
		UNTIL(!query.in_progress)
		if(qdel)
			qdel(query)

	if(log)
		log_debug("Executed [LAZYLEN(querys)] queries in [stop_watch(start_time)]s")

/**
  * # db_query
  *
  * Datum based handler for all database queries
  *
  * Holds information regarding inputs, status, and outputs
  */
/datum/db_query
	// Inputs
	/// The connection being used with this query
	var/connection
	/// The SQL statement being executed with :parameter placeholders
	var/sql
	/// An associative list of parameters to be substituted into the statement
	var/arguments

	// Status information
	/// Is the query currently in progress
	var/in_progress
	/// What was our last error, if any
	var/last_error
	/// What was our last activity
	var/last_activity
	/// When was our last activity
	var/last_activity_time

	// Output
	/// List of all rows returned
	var/list/list/rows
	/// Counter of the next row to take
	var/next_row_to_take = 1
	/// How many rows were affected by the query
	var/affected
	/// ID of the last inserted row
	var/last_insert_id
	/// List of data values populated by NextRow()
	var/list/item

// Sets up some vars and throws it into the SS active query list
/datum/db_query/New(connection, sql, arguments)
	SSdbcore.active_queries[src] = TRUE
	Activity("Created")
	item = list()

	src.connection = connection
	src.sql = sql
	src.arguments = arguments

// Takes it out of the active query list, as well as closing it up
/datum/db_query/Destroy()
	Close()
	SSdbcore.active_queries -= src
	return ..()

// Don't allow to call any proc on db_query
/datum/db_query/CanProcCall(procname)
	return FALSE

/**
  * Activity Update Handler
  *
  * Sets the last activity text to the argument input, as well as updating the activity time
  *
  * Arguments:
  * * activity - Last activity text
  */
/datum/db_query/proc/Activity(activity)
	last_activity = activity
	last_activity_time = world.time

/**
  * Wrapped for warning on execution
  *
  * You should use this proc when running the SQL statement. It will auto inform the user and the online admins if a query fails
  *
  * Arguments:
  * * async - Are we running this query asynchronously
  * * log_error - Do we want to log errors this creates? Disable this if you are running sensitive queries where you dont want errors logged in plain text (EG: Auth token stuff)
  */
/datum/db_query/proc/warn_execute(async = TRUE, log_error = TRUE)
	. = Execute(async, log_error)
	if(!.)
		SSdbcore.total_errors++
		if(usr)
			to_chat(usr, SPAN_DANGER("An SQL error occurred during this operation, please inform an admin or a coder."))
		message_admins("An SQL error has occured. Please check the server logs, with the following timestamp ID: \[[time_stamp()]]")

/**
  * Main Execution Handler
  *
  * Invoked by [warn_execute()]
  * This handles query error logging, as well as invoking the actual runner
  * Arguments:
  * * async - Are we running this query asynchronously
  * * log_error - Do we want to log errors this creates? Disable this if you are running sensitive queries where you dont want errors logged in plain text (EG: Auth token stuff)
  */
/datum/db_query/proc/Execute(async = TRUE, log_error = TRUE)
	Activity("Execute")
	if(in_progress)
		CRASH("Attempted to start a new query while waiting on the old one")

	if(!SSdbcore.IsConnected())
		last_error = "No connection!"
		return FALSE

	var/start_time
	if(!async)
		start_time = REALTIMEOFDAY
	Close()
	. = run_query(async)
	var/timed_out = !. && findtext(last_error, "Operation timed out")
	if(!. && log_error)
		log_sql("[last_error] | Query used: [sql] | Arguments: [json_encode(arguments)]")
	if(!async && timed_out)
		log_sql("Query execution started at [start_time]")
		log_sql("Query execution ended at [REALTIMEOFDAY]")
		log_sql("Slow query timeout detected.")
		log_sql("Query used: [sql]")
		slow_query_check()

/**
  * Actual Query Runner
  *
  * This does the main query with the database and the rust calls themselves
  *
  * Arguments:
  * * async - Are we running this query asynchronously
  */
/datum/db_query/proc/run_query(async)
	var/job_result_str

	if(async)
		var/job_id = rustg_sql_query_async(connection, sql, json_encode(arguments))
		in_progress = TRUE
		UNTIL((job_result_str = rustg_sql_check_query(job_id)) != RUSTG_JOB_NO_RESULTS_YET)
		in_progress = FALSE

		if(job_result_str == RUSTG_JOB_ERROR)
			last_error = job_result_str
			return FALSE
	else
		job_result_str = rustg_sql_query_blocking(connection, sql, json_encode(arguments))

	var/result = json_decode(job_result_str)
	switch(result["status"])
		if("ok")
			rows = result["rows"]
			affected = result["affected"]
			last_insert_id = result["last_insert_id"]
			return TRUE
		if("err")
			last_error = result["data"]
			return FALSE
		if("offline")
			last_error = "offline"
			return FALSE

// Just tells the admins if a query timed out, and asks if the server hung to help error reporting
/datum/db_query/proc/slow_query_check()
	message_admins("HEY! A database query timed out. Did the server just hang? <a href='?_src_=holder;slowquery=yes'>\[YES\]</a>|<a href='?_src_=holder;slowquery=no'>\[NO\]</a>")


/**
  * Proc to get the next row in a DB query
  *
  * Cycles `item` to the next row in the DB query, if multiple were fetched
  */
/datum/db_query/proc/NextRow()
	Activity("NextRow")

	if(rows && next_row_to_take <= LAZYLEN(rows))
		item = rows[next_row_to_take]
		next_row_to_take++
		return !!item
	else
		return FALSE

// Simple helper to get the last error a query had
/datum/db_query/proc/ErrorMsg()
	return last_error

// Simple proc to null out data to aid GC
/datum/db_query/proc/Close()
	rows = null
	item = null

// Verb that lets admins force reconnect the DB
/client/proc/reestablish_db_connection()
	set category = "Debug"
	set name = "Reestablish DB Connection"
	if(!sqlenabled)
		to_chat(usr, SPAN_WARNING("The Database is not enabled in the server configuration!"))
		return

	if(SSdbcore.IsConnected())
		if(!check_rights(R_DEBUG, FALSE))
			to_chat(usr, SPAN_WARNING("The database is already connected! (Only those with +DEBUG can force a reconnection)"))
			return

		var/reconnect = alert("The database is already connected! If you *KNOW* that this is incorrect, you can force a reconnection", "The database is already connected!", "Force Reconnect", "Cancel")
		if(reconnect != "Force Reconnect")
			return

		SSdbcore.Disconnect()
		log_admin("[key_name(usr)] has forced the database to disconnect")
		message_admins("[key_name_admin(usr)] has <b>forced</b> the database to disconnect!!!")

	log_admin("[key_name(usr)] is attempting to re-establish the DB Connection")
	message_admins("[key_name_admin(usr)] is attempting to re-establish the DB Connection")

	SSdbcore.failed_connections = 0 // Reset this
	if(!SSdbcore.Connect())
		message_admins("Database connection failed: [SSdbcore.ErrorMsg()]")
	else
		message_admins("Database connection re-established")
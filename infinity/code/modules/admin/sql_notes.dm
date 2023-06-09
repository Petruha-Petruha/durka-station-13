/proc/add_note(target_ckey, notetext, timestamp, adminckey, logged = 1, server)
	if(!check_rights(R_INVESTIGATE, 1, usr)) return

	if(!dbcon.IsConnected())
		to_chat(usr, "<span class='danger'>Failed to establish database connection.</span>")
		return

	if(!target_ckey)
		var/new_ckey = ckey(input(usr,"Who would you like to add a note for?","Enter a ckey",null) as text)
		if(!new_ckey)
			return
		new_ckey = sanitizeSQL(new_ckey)
		var/DBQuery/query_find_ckey = dbcon.NewQuery("SELECT ckey FROM erro_player WHERE ckey = '[new_ckey]'")
		if(!query_find_ckey.Execute())
			var/err = query_find_ckey.ErrorMsg()
			log_game("SQL ERROR obtaining ckey from player table. Error : \[[err]\]\n")
			return
		if(!query_find_ckey.NextRow())
			if(alert(usr, "[new_ckey] has not been seen before, are you sure you want to add them to the watchlist?", "Unknown ckey", "Yes", "No", "Cancel") != "Yes")
				return
		target_ckey = new_ckey
	var/target_sql_ckey = sanitizeSQL(target_ckey)
	if(!notetext)
		notetext = input(usr,"Write your Note","Add Note") as message
		if(!notetext)
			return
	notetext = sanitizeSQL(notetext)
	if(!timestamp)
		timestamp = SQLtime()
	if(!adminckey)
		adminckey = usr.ckey
		if(!adminckey)
			return
	var/admin_sql_ckey = sanitizeSQL(adminckey)
	if(!server)
		if (config && config.server_name)
			server = config.server_name
	server = sanitizeSQL(server)
	var/DBQuery/query_noteadd = dbcon.NewQuery("INSERT INTO erro_messages (type, targetckey, adminckey, text, timestamp, server) VALUES ('note', '[target_sql_ckey]', '[admin_sql_ckey]', '[notetext]', '[timestamp]', '[server]')")
	if(!query_noteadd.Execute())
		var/err = query_noteadd.ErrorMsg()
		log_game("SQL ERROR adding new note to table. Error : \[[err]\]\n")
		return
	if(logged)
		log_admin("[key_name(usr)] has added a note to [target_ckey]: [notetext]")
		message_admins("[key_name_admin(usr)] has added a note to [target_ckey]:<br>[notetext]")
		send2adminirc("[get_key(usr)] добавил нотес игроку [target_ckey]: \"[notetext]\"")
		show_note(target_ckey)

/proc/remove_note(note_id)
	var/ckey
	var/notetext
	var/adminckey

	if(!check_rights(R_INVESTIGATE, 1, usr)) return

	if(!dbcon.IsConnected())
		to_chat(usr, "<span class='danger'>Failed to establish database connection.</span>")
		return
	if(!note_id)
		return
	note_id = text2num(note_id)
	var/DBQuery/query_find_note_del = dbcon.NewQuery("SELECT targetckey, text, adminckey FROM erro_messages WHERE id = [note_id] and type = 'note'")
	if(!query_find_note_del.Execute())
		var/err = query_find_note_del.ErrorMsg()
		log_game("SQL ERROR obtaining targetckey, text, adminckey from erro_messages table. Error : \[[err]\]\n")
		return
	if(query_find_note_del.NextRow())
		ckey = query_find_note_del.item[1]
		notetext = query_find_note_del.item[2]
		adminckey = query_find_note_del.item[3]
	var/DBQuery/query_del_note = dbcon.NewQuery("DELETE FROM erro_messages WHERE id = [note_id]")
	if(!query_del_note.Execute())
		var/err = query_del_note.ErrorMsg()
		log_game("SQL ERROR removing note from table. Error : \[[err]\]\n")
		return
	log_admin("[key_name(usr)] has removed a note made by [adminckey] from [ckey]: [notetext]")
	message_admins("[key_name_admin(usr)] has removed a note made by [adminckey] from [ckey]:<br>[notetext]")
	send2adminirc("[get_key(usr)] убрал нотес от [adminckey] у игрока [ckey]: \"[notetext]\"")
	show_note(ckey)

/proc/edit_note(note_id)
	if(!check_rights(R_INVESTIGATE, 1, usr)) return

	if(!dbcon.IsConnected())
		to_chat(usr, "<span class='danger'>Failed to establish database connection.</span>")
		return
	if(!note_id)
		return
	note_id = text2num(note_id)
	var/target_ckey
	var/sql_ckey = sanitizeSQL(usr.ckey)
	var/DBQuery/query_find_note_edit = dbcon.NewQuery("SELECT targetckey, text, adminckey FROM erro_messages WHERE id = [note_id] and type = 'note'")
	if(!query_find_note_edit.Execute())
		var/err = query_find_note_edit.ErrorMsg()
		log_game("SQL ERROR obtaining notetext from erro_messages table. Error : \[[err]\]\n")
		return
	if(query_find_note_edit.NextRow())
		target_ckey = query_find_note_edit.item[1]
		var/old_note = query_find_note_edit.item[2]
		var/adminckey = query_find_note_edit.item[3]
		var/new_note = input("Input new note", "New Note", "[old_note]") as message
		if(!new_note)
			return
		new_note = sanitizeSQL(new_note)
		var/edit_text = "Edited by [sql_ckey] on [SQLtime()] from<br>[old_note]<br>to<br>[new_note]<hr>"
		edit_text = sanitizeSQL(edit_text)
		var/DBQuery/query_update_note = dbcon.NewQuery("UPDATE erro_messages SET text = '[new_note]', lasteditor = '[sql_ckey]', edits = CONCAT(IFNULL(edits,''),'[edit_text]') WHERE id = [note_id]")

		if(!query_update_note.Execute())
			var/err = query_update_note.ErrorMsg()
			log_game("SQL ERROR editing note. Error : \[[err]\]\n")
			return
		log_admin("[key_name(usr)] has edited [target_ckey]'s note made by [adminckey] from [old_note] to [new_note]")
		message_admins("[key_name_admin(usr)] has edited [target_ckey]'s note made by [adminckey] from<br>[old_note]<br>to<br>[new_note]")
		send2adminirc("[get_key(usr)] изменил нотес [adminckey] у игрока [target_ckey] с - \"[old_note]\" на - \"[new_note]\"")
		show_note(target_ckey)

/proc/show_note(target_ckey, index, linkless = 0)
	var/output
	var/navbar
	var/ruler
	ruler = "<hr style='background:#000000; border:0; height:3px'>"
	navbar = "<a href='?_src_=holder;nonalpha=1'>\[All\]</a>|<a href='?_src_=holder;nonalpha=2'>\[#\]</a>"
	for(var/letter in alphabet)
		navbar += "|<a href='?_src_=holder;shownote=[letter]'>\[[letter]\]</a>"
	navbar += "<br><form method='GET' name='search' action='?'>\
	<input type='hidden' name='_src_' value='holder'>\
	<input type='text' name='notessearch' value='[index]'>\
	<input type='submit' value='Search'></form>"
	if(!linkless && check_rights(R_INVESTIGATE, 0, usr))
		output = navbar
	if(target_ckey)
		var/target_sql_ckey = sanitizeSQL(target_ckey)
		var/DBQuery/query_get_notes = dbcon.NewQuery("SELECT id, timestamp, text, adminckey, lasteditor, server FROM erro_messages WHERE targetckey = '[target_sql_ckey]' and type = 'note' ORDER BY timestamp")
		if(!query_get_notes.Execute())
			var/err = query_get_notes.ErrorMsg()
			log_game("SQL ERROR obtaining ckey, notetext, adminckey, last_editor, server from notes table. Error : \[[err]\]\n")
			to_chat(usr, "No DB connection founded. Please, report to development team. Code: TC.")
			return
		output += "<h2><center>Notes of [target_ckey]</center></h2>"
		if(!linkless && check_rights(R_INVESTIGATE, 0, usr))
			output += "<center><a href='?_src_=holder;addnote=[target_ckey]'>\[Add Note\]</a></center>"
		output += ruler
		while(query_get_notes.NextRow())
			var/id = query_get_notes.item[1]
			var/timestamp = query_get_notes.item[2]
			var/notetext = query_get_notes.item[3]
			var/adminckey = query_get_notes.item[4]
			var/last_editor = query_get_notes.item[5]
			var/server = query_get_notes.item[6]
			output += "<b>[timestamp] | [server] | [adminckey]</b>"
			if(!linkless && check_rights(R_INVESTIGATE, 0, usr))
				output += " <a href='?_src_=holder;removenote=[id]'>\[Remove Note\]</a> <a href='?_src_=holder;editnote=[id]'>\[Edit Note\]</a>"
				if(last_editor)
					output += " <font size='2'>Last edit by [last_editor] <a href='?_src_=holder;noteedits=[id]'>(Click here to see edit log)</a></font>"
			output += "<br>[notetext]<hr style='background:#000000; border:0; height:1px'>"
	else if(index)
		var/index_ckey
		var/search
		if(check_rights(R_INVESTIGATE, 0, usr))
			output += "<center><a href='?_src_=holder;addnoteempty=1'>\[Add Note\]</a></center>"
		output += ruler
		if(!isnum(index))
			index = sanitizeSQL(index)
		switch(index)
			if(1)
				search = "^."
			if(2)
				search = "^\[^\[:alpha:\]\]"
			else
				search = "^[index]"
		var/DBQuery/query_list_notes = dbcon.NewQuery("SELECT DISTINCT targetckey FROM erro_messages WHERE targetckey REGEXP '[search]' ORDER BY targetckey")
		if(!query_list_notes.Execute())
			var/err = query_list_notes.ErrorMsg()
			log_game("SQL ERROR obtaining ckey from erro_messages table. Error : \[[err]\]\n")
			to_chat(usr, "No DB connection founded. Please, report to development team. Code: Index.")
			return
		while(query_list_notes.NextRow())
			index_ckey = query_list_notes.item[1]
			output += "<a href='?_src_=holder;shownoteckey=[index_ckey]'>[index_ckey]</a><br>"
	else
		if(check_rights(R_INVESTIGATE, 0, usr))
			output += "<center><a href='?_src_=holder;addnoteempty=1'>\[Add Note\]</a></center>"
		output += ruler
	show_browser(usr, output, "window=show_notes;size=900x500")

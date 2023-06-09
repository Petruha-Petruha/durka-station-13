/decl/communication_channel/ooc
	name = "OOC"
	config_setting = "ooc_allowed"
	expected_communicator_type = /client
	flags = COMMUNICATION_NO_GUESTS
	log_proc = /proc/log_ooc
	mute_setting = MUTE_OOC
	show_preference_setting = /datum/client_preference/show_ooc

/decl/communication_channel/ooc/can_communicate(var/client/C, var/message)
	. = ..()
	if(!.)
		return

	if(!C.holder)
		if(!config.dooc_allowed && (C.mob.stat == DEAD))
			to_chat(C, SPAN_DANGER("[name] for dead mobs has been turned off."))
			return FALSE
//[INF]
		if(findtext(message, "byond://"))
			to_chat(C, "<B>Реклама стороних проектов не поощеряется =(</B>")
			log_and_message_admins("has attempted to advertise in [name]: [message]")
			return FALSE
	if(name == "OOC" && !config.ooc_allowed && !check_rights(R_PERMISSIONS, 0, C))
		to_chat(C, SPAN_DANGER("Вы не можете использовать отключённый канал."))
		return FALSE
//[/INF]

/decl/communication_channel/ooc/do_communicate(var/client/C, var/message)
	var/datum/admins/holder = C.holder
	var/is_stealthed = C.is_stealthed()

	var/ooc_style = "everyone"
	if(holder && !is_stealthed) // You have an admin datum AND not stealth-admined.
		ooc_style = "elevated"
		if(holder.rights & R_ADMIN) // You are an admin first of all.
			ooc_style = "admin"
		else if(holder.rights & R_DEBUG) // Not an admin, but have debug? Developer color then.
			ooc_style = "developer"
		else if(holder.rights & R_MOD) // None of it applies? Become moderator-colored.
			ooc_style = "moderator"
	var/holder_rank = ""
	if(holder && !is_stealthed)
		holder_rank = "\[[holder.rank]\] "


	for(var/client/target in GLOB.clients)
		if(target.is_key_ignored(C.key)) // If we're ignored by this person, then do nothing.
			continue
		var/sent_message = "[create_text_tag("ooc", "OOC:", target)] [text_badge(C)]  <EM>" + "[holder_rank]" + "[C.key]:</EM> <span class='message linkify'>[message]</span>"
		sent_message = emoji_parse_by_user(sent_message, C)//inf
		if(!is_stealthed && C.prefs.ooccolor != initial(C.prefs.ooccolor))
			receive_communication(C, target, "<font color='[C.prefs.ooccolor]'><span class='ooc'>[sent_message]</font></span>")
		else
			receive_communication(C, target, "<span class='ooc'><span class='[ooc_style]'>[sent_message]</span></span>")

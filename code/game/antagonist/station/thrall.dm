GLOBAL_DATUM_INIT(thralls, /datum/antagonist/thrall, new)

/datum/antagonist/thrall
	role_text = "Thrall"
	role_text_plural = "Thralls"
	welcome_text = "Ваш разум больше не принадлежит только вам..."
	id = MODE_THRALL
	flags = ANTAG_IMPLANT_IMMUNE
	ambitious = 0 //INF

	var/list/thrall_controllers = list()

/datum/antagonist/thrall/create_objectives(var/datum/mind/player)
	var/mob/living/controller = thrall_controllers["\ref[player]"]
	if(!controller)
		return // Someone is playing with buttons they shouldn't be.
	var/datum/objective/obey = new
	obey.owner = player
	obey.explanation_text = "Повинуйтесь своему хозяину, [controller.real_name], во всем."
	player.objectives |= obey

/datum/antagonist/thrall/add_antagonist(var/datum/mind/player, var/ignore_role, var/do_not_equip, var/move_to_spawn, var/do_not_announce, var/preserve_appearance, var/mob/new_controller)
	if(!new_controller)
		return 0
	. = ..()
	if(.) thrall_controllers["\ref[player]"] = new_controller

/datum/antagonist/thrall/greet(var/datum/mind/player)
	. = ..()
	var/mob/living/controller = thrall_controllers["\ref[player]"]
	if(controller)
		to_chat(player, "<span class='danger'>Ваша воля была подчинена воле [controller.real_name]. Повинуйтесь ему во всем.</span>")

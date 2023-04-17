/obj/machinery/photocopier
	name = "photocopier"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "photocopier"
	var/insert_anim = "photocopier_animation"
	anchored = TRUE
	density = TRUE
	idle_power_usage = 30
	active_power_usage = 200
	power_channel = EQUIP
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_CLIMBABLE
	obj_flags = OBJ_FLAG_ANCHORABLE

	var/obj/item/copyitem = null	//what's in the copier!
	var/copies = 1	//how many copies to print!
	var/toner = 30 //how much toner is left! woooooo~
	var/maxcopies = 10	//how many copies can be copied at once- idea shamelessly stolen from bs12's copier!
	var/copying = FALSE // Is the printer busy with something? Sanity check variable.


/obj/machinery/photocopier/examine(mob/user as mob)
	. = ..()
	if(Adjacent(user))
		. += "The screen shows there's [toner ? "[toner]" : "no"] toner left in the printer."

/obj/machinery/photocopier/attack_ai(mob/user as mob)
	return attack_hand(user)

/obj/machinery/photocopier/attack_hand(mob/user as mob)
	tgui_interact(user)

/obj/machinery/photocopier/tgui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Photocopier", name)
		ui.open()

/obj/machinery/photocopier/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	data["has_item"] = copyitem
	data["isAI"] = issilicon(user)
	data["can_AI_print"] = (toner >= 5)
	data["has_toner"] =	!!toner
	data["current_toner"] = toner
	data["max_toner"] = 30
	data["num_copies"] = copies
	data["max_copies"] = maxcopies

	return data

/obj/machinery/photocopier/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	switch(action)
		if("make_copy")
			addtimer(CALLBACK(src, .proc/copy_operation, usr), 0)
		if("remove")
			if(copyitem)
				copyitem.loc = usr.loc
				usr.put_in_hands(copyitem)
				to_chat(usr, "<span class='notice'>You take \the [copyitem] out of \the [src].</span>")
				copyitem = null
		if("set_copies")
			copies = clamp(text2num(params["num_copies"]), 1, maxcopies)
		if("ai_photo")
			if(!issilicon(usr))
				return
			if(stat & (BROKEN|NOPOWER))
				return

			if(toner >= 5)
				var/mob/living/silicon/tempAI = usr
				var/obj/item/device/camera/siliconcam/camera = tempAI.silicon_camera

				if(!camera)
					return
				var/obj/item/photo/selection = camera.selectpicture()
				if (!selection)
					return

				var/obj/item/photo/p = photocopy(selection)
				if (p.desc == "")
					p.desc += "Copied by [tempAI.name]"
				else
					p.desc += " - Copied by [tempAI.name]"
				toner -= 5

	return TRUE

/obj/machinery/photocopier/proc/copy_operation(var/mob/user, mob/living/M)
	if(copying)
		return FALSE
	copying = TRUE
	for(var/i = 0, i < copies, i++)
		if(toner <= 0)
			break

		if (istype(copyitem, /obj/item/paper))
			playsound(loc, "sound/machines/copier.ogg", 100, 1)
			sleep(11)
			copy(copyitem)
			audible_message("<span class='notice'>You can hear [src] whirring as it finishes printing.</span>")
			playsound(loc, "sound/machines/buzzbeep.ogg", 30)
		else if (istype(copyitem, /obj/item/photo))
			playsound(loc, "sound/machines/copier.ogg", 100, 1)
			sleep(11)
			photocopy(copyitem)
			audible_message("<span class='notice'>You can hear [src] whirring as it finishes printing.</span>")
			playsound(loc, "sound/machines/buzzbeep.ogg", 30)
		else if (istype(copyitem, /obj/item/paper_bundle))
			sleep(11)
			playsound(loc, "sound/machines/copier.ogg", 100, 1)
			var/obj/item/paper_bundle/B = bundlecopy(copyitem)
			sleep(11*B.pages.len)
			audible_message("<span class='notice'>You can hear [src] whirring as it finishes printing.</span>")
			playsound(loc, "sound/machines/buzzbeep.ogg", 30)
		else
			to_chat(user, "<span class='warning'>\The [copyitem] can't be copied by [src].</span>")
			playsound(loc, "sound/machines/buzz-two.ogg", 100)
			break

		//use_power(active_power_usage)
	copying = FALSE

/obj/machinery/photocopier/Topic(href, href_list)
	if(href_list["copy"])
		if(stat & (BROKEN|NOPOWER))
			return
		addtimer(CALLBACK(src, .proc/copy_operation, usr), 0)

	else if(href_list["remove"])
		if(copyitem)
			copyitem.loc = usr.loc
			usr.put_in_hands(copyitem)
			to_chat(usr, "<span class='notice'>You take \the [copyitem] out of \the [src].</span>")
			copyitem = null
		else if(buckled_mob)
			to_chat(buckled_mob[src], "<span class='notice'>You feel a slight pressure on your ass.</span>") // It can't eject your asscheeks, but it'll try.
			return TOPIC_REFRESH
	else if(href_list["min"])
		if(copies > 1)
			copies--
	else if(href_list["add"])
		if(copies < maxcopies)
			copies++
	else if(href_list["aipic"])
		if(!istype(usr, /mob/living/silicon)) return
		if(stat & (BROKEN|NOPOWER)) return

		if(toner >= 5)
			var/mob/living/silicon/tempAI = usr
			var/obj/item/device/camera/siliconcam/camera = tempAI.silicon_camera

			if(!camera)
				return
			var/obj/item/photo/selection = camera.selectpicture()
			if (!selection)
				return

			var/obj/item/photo/p = photocopy(selection)
			if (p.desc == "")
				p.desc += "Copied by [tempAI.name]"
			else
				p.desc += " - Copied by [tempAI.name]"
			toner -= 5
			sleep(15)

	SSnano.update_uis(src)

/obj/machinery/photocopier/attackby(obj/item/O as obj, mob/user as mob)
	if(istype(O, /obj/item/paper) || istype(O, /obj/item/photo) || istype(O, /obj/item/paper_bundle))
		if(!copyitem)
			user.drop_item()
			copyitem = O
			O.loc = src
			to_chat(user, "<span class='notice'>You insert \the [O] into \the [src].</span>")
			playsound(loc, "sound/machines/click.ogg", 100, 1)
			flick(insert_anim, src)
		else
			to_chat(user, "<span class='notice'>There is already something in \the [src].</span>")
	else if(istype(O, /obj/item/device/toner))
		if(toner <= 10) //allow replacing when low toner is affecting the print darkness
			user.drop_item()
			to_chat(user, "<span class='notice'>You insert the toner cartridge into \the [src].</span>")
			var/obj/item/device/toner/T = O
			toner += T.toner_amount
			qdel(O)
		else
			to_chat(user, "<span class='notice'>This cartridge is not yet ready for replacement! Use up the rest of the toner.</span>")
	else if(isWrench(O))
		//playsound(loc, O.usesound, 50, 1)
		anchored = !anchored
		to_chat(user, "<span class='notice'>You [anchored ? "wrench" : "unwrench"] \the [src].</span>")
	return

/obj/machinery/photocopier/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
		if(2.0)
			if(prob(50))
				qdel(src)
			else
				if(toner > 0)
					new /obj/effect/decal/cleanable/blood/oil(get_turf(src))
					toner = 0
		else
			if(prob(50))
				if(toner > 0)
					new /obj/effect/decal/cleanable/blood/oil(get_turf(src))
					toner = 0
	return

/obj/machinery/photocopier/proc/copy(var/obj/item/paper/copy, var/need_toner=1)
	var/obj/item/paper/c = new /obj/item/paper (loc)
	if(toner > 10)	//lots of toner, make it dark
		c.info = "<font color = #101010>"
	else			//no toner? shitty copies for you!
		c.info = "<font color = #808080>"
	var/copied = html_decode(copy.info)
	copied = replacetext(copied, "<font face=\"[c.deffont]\" color=", "<font face=\"[c.deffont]\" nocolor=")	//state of the art techniques in action
	copied = replacetext(copied, "<font face=\"[c.crayonfont]\" color=", "<font face=\"[c.crayonfont]\" nocolor=")	//This basically just breaks the existing color tag, which we need to do because the innermost tag takes priority.
	c.info += copied
	c.info += "</font>"//</font>
	c.name = copy.name // -- Doohl
	c.fields = copy.fields
	c.stamps = copy.stamps
	c.stamped = copy.stamped
	c.ico = copy.ico
	c.offset_x = copy.offset_x
	c.offset_y = copy.offset_y
	var/list/temp_overlays = copy.overlays       //Iterates through stamps
	var/image/img                                //and puts a matching
	for (var/j = 1, j <= min(temp_overlays.len, copy.ico.len), j++) //gray overlay onto the copy
		if (findtext(copy.ico[j], "cap") || findtext(copy.ico[j], "cent"))
			img = image('icons/obj/bureaucracy.dmi', "paper_stamp-circle")
		else if (findtext(copy.ico[j], "deny"))
			img = image('icons/obj/bureaucracy.dmi', "paper_stamp-x")
		else
			img = image('icons/obj/bureaucracy.dmi', "paper_stamp-dots")
		img.pixel_x = copy.offset_x[j]
		img.pixel_y = copy.offset_y[j]
		c.overlays += img
	c.updateinfolinks()
	c.update_icon()
	if(need_toner)
		toner--
	if(toner == 0)
		playsound(loc, "sound/machines/buzz-sigh.ogg", 100)
		visible_message("<span class='notice'>A red light on \the [src] flashes, indicating that it is out of toner.</span>")
	c.update_icon()
	return c


/obj/machinery/photocopier/proc/photocopy(var/obj/item/photo/photocopy, var/need_toner=1)
	var/obj/item/photo/p = photocopy.copy()
	p.loc = src.loc

	var/icon/I = icon(photocopy.icon, photocopy.icon_state)
	if(toner > 10)	//plenty of toner, go straight greyscale
		I.MapColors(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(0,0,0))		//I'm not sure how expensive this is, but given the many limitations of photocopying, it shouldn't be an issue.
		p.img.MapColors(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(0,0,0))
		//p.tiny.MapColors(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(0,0,0))
	else			//not much toner left, lighten the photo
		I.MapColors(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(100,100,100))
		p.img.MapColors(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(100,100,100))
		//p.tiny.MapColors(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(100,100,100))
	p.icon = I
	if(need_toner)
		toner -= 5	//photos use a lot of ink!
	if(toner < 0)
		toner = 0
		playsound(loc, "sound/machines/buzz-sigh.ogg", 100)
		visible_message("<span class='notice'>A red light on \the [src] flashes, indicating that it is out of toner.</span>")

	return p

//If need_toner is 0, the copies will still be lightened when low on toner, however it will not be prevented from printing. TODO: Implement print queues for fax machines and get rid of need_toner
/obj/machinery/photocopier/proc/bundlecopy(var/obj/item/paper_bundle/bundle, var/need_toner=1)
	var/obj/item/paper_bundle/p = new /obj/item/paper_bundle (src)
	for(var/obj/item/W in bundle.pages)
		if(toner <= 0 && need_toner)
			toner = 0
			playsound(loc, "sound/machines/buzz-sigh.ogg", 100)
			visible_message("<span class='notice'>A red light on \the [src] flashes, indicating that it is out of toner.</span>")
			break

		if(istype(W, /obj/item/paper))
			W = copy(W)
		else if(istype(W, /obj/item/photo))
			W = photocopy(W)
		W.loc = p
		p.pages += W

	p.loc = src.loc
	p.update_icon()
	p.icon_state = "paper_words"
	p.name = bundle.name
	p.pixel_y = rand(-8, 8)
	p.pixel_x = rand(-9, 9)
	return p

/obj/machinery/photocopier/unsecured
	anchored = FALSE

/obj/item/device/toner
	name = "toner cartridge"
	icon_state = "tonercartridge"
	var/toner_amount = 30
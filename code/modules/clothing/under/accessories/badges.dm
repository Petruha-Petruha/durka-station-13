/*
	Badges are worn on the belt or neck, and can be used to show the user's credentials.
	The user' details can be imprinted on holobadges with the relevant ID card,
	or they can be emagged to accept any ID for use in disguises.
*/

/obj/item/clothing/accessory/badge
	name = "badge"
	desc = "NanoTrasen Security Department detective's badge, made from gold."
	icon_state = "marshalbadge"
	slot_flags = SLOT_BELT | SLOT_TIE
	slot = ACCESSORY_SLOT_INSIGNIA // ACCESSORY_SLOT_MEDAL
	high_visibility = 1
	var/badge_string = "Detective"
	var/stored_name
//[INF]
/obj/item/clothing/accessory/badge/inherit_custom_item_data(datum/custom_item/citem)
	. = ..()
	if(list_find(citem.additional_data, "badge_string"))
		badge_string = citem.additional_data["badge_string"]
	if(list_find(citem.additional_data, "stored_name"))
		stored_name = citem.additional_data["stored_name"]
//[/INF]
/obj/item/clothing/accessory/badge/get_lore_info()
	. = ..()
	. += "<br>Denotes affiliation to <l>[badge_string]</l>."

/obj/item/clothing/accessory/badge/proc/set_name(var/new_name)
	stored_name = new_name

/obj/item/clothing/accessory/badge/proc/set_desc(var/mob/living/carbon/human/H)

/obj/item/clothing/accessory/badge/CanUseTopic(var/user)
	if(user in view(get_turf(src)))
		return STATUS_INTERACTIVE

/obj/item/clothing/accessory/badge/OnTopic(var/mob/user, var/list/href_list)
	if(href_list["look_at_me"])
		if(istype(user))
			user.examinate(src)
			return TOPIC_HANDLED

/obj/item/clothing/accessory/badge/get_examine_line()
	. = ..()
	. += "  <a href='?src=\ref[src];look_at_me=1'>\[View\]</a>"

/obj/item/clothing/accessory/badge/examine(user)
	. = ..()
	if(stored_name)
		to_chat(user,"It reads: [stored_name], [badge_string].")

/obj/item/clothing/accessory/badge/attack_self(mob/user as mob)

	if(!stored_name)
		to_chat(user, "You inspect your [src.name]. Everything seems to be in order and you give it a quick cleaning with your hand.")
		set_name(user.real_name)
		set_desc(user)
		return

	if(isliving(user))
		if(stored_name)
			user.visible_message("<span class='notice'>[user] displays their [src.name].\nIt reads: [stored_name], [badge_string].</span>","<span class='notice'>You display your [src.name].\nIt reads: [stored_name], [badge_string].</span>")
		else
			user.visible_message("<span class='notice'>[user] displays their [src.name].\nIt reads: [badge_string].</span>","<span class='notice'>You display your [src.name]. It reads: [badge_string].</span>")

/obj/item/clothing/accessory/badge/attack(mob/living/carbon/human/M, mob/living/user)
	if(isliving(user))
		user.visible_message("<span class='danger'>[user] invades [M]'s personal space, thrusting \the [src] into their face insistently.</span>","<span class='danger'>You invade [M]'s personal space, thrusting \the [src] into their face insistently.</span>")
		if(stored_name)
			to_chat(M, "<span class='warning'>It reads: [stored_name], [badge_string].</span>")

/obj/item/clothing/accessory/badge/PI
	name = "private investigator's badge"
	badge_string = "Private Investigator"

/*
 *Holobadges
 */
/obj/item/clothing/accessory/badge/holo
	name = "holobadge"
	desc = "This glowing blue badge marks the holder as a member of security."
	color = COLOR_PALE_BLUE_GRAY
	icon_state = "holobadge"
	item_state = "holobadge"
	badge_string = "Security"
	var/badge_access = access_security
	var/badge_number
	var/emagged //emag_act removes access requirements

/obj/item/clothing/accessory/badge/holo/officer
	name = "officer's badge"
	desc = "A bronze corporate security badge. Stamped with the words 'Security Officer.'"
	icon_state = "bronzebadge"
	slot_flags = SLOT_TIE | SLOT_BELT

/obj/item/clothing/accessory/badge/holo/warden
	name = "warden's holobadge"
	desc = "A silver corporate security badge. Stamped with the words 'Warden.'"
	icon_state = "silverbadge"
	slot_flags = SLOT_TIE | SLOT_BELT

/obj/item/clothing/accessory/badge/holo/hos
	name = "head of security's holobadge"
	desc = "An immaculately polished gold security badge. Stamped with the words 'Head of Security.'"
	icon_state = "goldbadge"
	slot_flags = SLOT_TIE | SLOT_BELT

/obj/item/clothing/accessory/badge/holo/investigator
	name = "\improper Internal Investigations holobadge"
	desc = "This badge marks the holder as an internal affairs investigator."
	icon_state = "invbadge"
	badge_string = "Internal Investigations"
	slot_flags = SLOT_TIE | SLOT_BELT

/obj/item/clothing/accessory/badge/holo/sheriff
	name = "sheriff badge"
	desc = "A star-shaped brass badge denoting who the law is around these parts."
	icon_state = "sheriff"
	slot_flags = SLOT_TIE | SLOT_BELT

/obj/item/clothing/accessory/badge/holo/NT
	name = "corporate holobadge"
	desc = "This glowing green badge marks the holder as a member of corporate security."
	icon_state = "ntholobadge"
	color = null
	badge_string = "Corporate Security"
	badge_access = access_security
	slot = ACCESSORY_SLOT_INSIGNIA
	slot_flags = SLOT_TIE | SLOT_BELT

/obj/item/clothing/accessory/badge/holo/cord
	icon_state = "holobadge-cord"
	slot_flags = SLOT_MASK | SLOT_TIE

/obj/item/clothing/accessory/badge/holo/NT/cord
	icon_state = "holobadge-cord"
	slot_flags = SLOT_MASK | SLOT_TIE

/obj/item/clothing/accessory/badge/holo/set_name(var/new_name)
	..()
	badge_number = random_id(type,1000,9999)
	name = "[initial(name)] ([badge_number])"

/obj/item/clothing/accessory/badge/holo/examine(user)
	. = ..()
	if(badge_number)
		to_chat(user,"The badge number is [badge_number].")

/obj/item/clothing/accessory/badge/holo/attack_self(mob/user as mob)
	if(!stored_name)
		to_chat(user, "Waving around a holobadge before swiping an ID would be pretty pointless.")
		return
	return ..()

/obj/item/clothing/accessory/badge/holo/emag_act(var/remaining_charges, var/mob/user)
	if (emagged)
		to_chat(user, "<span class='danger'>\The [src] is already cracked.</span>")
		return
	else
		emagged = TRUE
		to_chat(user, "<span class='danger'>You crack the holobadge security checks.</span>")
		return 1

/obj/item/clothing/accessory/badge/holo/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(istype(O, /obj/item/card/id) || istype(O, /obj/item/modular_computer))

		var/obj/item/card/id/id_card = O.GetIdCard()

		if(!id_card)
			return

		if((badge_access in id_card.access) || emagged)
			to_chat(user, "You imprint your ID details onto the badge.")
			set_name(id_card.registered_name)
			set_desc(user)
		else
			to_chat(user, "[src] rejects your ID, and flashes 'Insufficient access!'")
		return
	..()

/obj/item/storage/box/holobadge
	name = "holobadge box"
	desc = "A box containing security holobadges."
	startswith = list(/obj/item/clothing/accessory/badge/holo = 4,
					  /obj/item/clothing/accessory/badge/holo/officer = 2,
					  /obj/item/clothing/accessory/badge/holo/cord = 2)

/obj/item/storage/box/holobadgeNT
	name = "corporate holobadge box"
	desc = "A box containing corporate security holobadges."
	startswith = list(/obj/item/clothing/accessory/badge/holo/NT = 4,
					  /obj/item/clothing/accessory/badge/holo/NT/cord = 2)

/obj/item/clothing/accessory/badge/old
	name = "faded badge"
	desc = "A faded law enforcement badge in an older design."
	icon_state = "badge_round"

/obj/item/clothing/accessory/badge/solid
	name = "\improper SolGov ID badge"
	desc = "A descriptive identification badge with the holder's credentials. This one indicates the holder is representing the SCG."
	icon_state = "solbadge"
	badge_string = null

/obj/item/clothing/accessory/badge/ntid
	name = "\improper NT ID badge"
	desc = "A descriptive identification badge with the holder's credentials. This one has red marks with the NanoTrasen logo on it."
	icon_state = "ntbadge"
	badge_string = null

/obj/item/clothing/accessory/badge/defenseintel
	name = "\improper DIA investigator's badge"
	desc = "A leather-backed silver badge bearing the crest of the Defense Intelligence Agency."
	icon_state = "diabadge"
	badge_string = "Defense Intelligence Agency"

/obj/item/clothing/accessory/badge/interstellarintel
	name = "\improper OII agent's badge"
	desc = "A synthleather holographic badge bearing the crest of the Office of Interstellar Intelligence."
	icon_state = "intelbadge"
	badge_string = "Office of Interstellar Intelligence"

/obj/item/clothing/accessory/badge/nanotrasen
	name = "corporate badge"
	desc = "A leather-backed plastic badge with a variety of information printed on it. Belongs to a corporate executive."
	icon_state = "ntbadge"
	badge_string = "Corporate Executive Body"

/obj/item/clothing/accessory/badge/agent
	name = "\improper SFP Agent's badge"
	desc = "A leather-backed gold badge displaying the crest of the Sol Federal Police."
	icon_state = "agentbadge"
	slot_flags = SLOT_BELT | SLOT_TIE | SLOT_MASK
	slot = ACCESSORY_SLOT_INSIGNIA
	badge_string = FACTION_SPACECOPS

/obj/item/clothing/accessory/badge/tracker
	name = "\improper Tracker's badge"
	desc = "A blue leather-backed gold badge displaying the crest of the Sol Federal Police."
	icon_state = "trackerbadge"
	slot_flags = SLOT_BELT | SLOT_TIE
	slot = ACCESSORY_SLOT_INSIGNIA
	badge_string = FACTION_SPACECOPS

/obj/item/clothing/accessory/badge/press
	name = "corporate press pass"
	desc = "A corporate reporter's pass, emblazoned with the NanoTrasen logo."
	icon_state = "pressbadge"
	badge_string = "Journalist"
	item_state = "pbadge"
	badge_string = "Corporate Reporter"
	w_class = ITEM_SIZE_TINY

/obj/item/clothing/accessory/badge/press/independent
	name = "press pass"
	desc = "A freelance journalist's pass, certified by Oculum Broadcast."
	icon_state = "pressbadge-i"
	badge_string = "Freelance Journalist"

/obj/item/clothing/accessory/badge/press/plastic
	name = "plastic press pass"
	desc = "A journalist's 'pass' shaped, for whatever reason, like a security badge. It is made of plastic."
	icon_state = "pbadge"
	badge_string = "Sicurity Journelist"
	w_class = ITEM_SIZE_SMALL

// Sheriff Badge (toy)
/obj/item/clothing/accessory/badge/sheriff
	name = "sheriff badge"
	desc = "This town ain't big enough for the two of us, pardner."
	icon_state = "sheriff"
	item_state = "goldbadge"
	icon_state = "sheriff_toy"
	item_state = "sheriff_toy"

/obj/item/clothing/accessory/badge/tags/skrell
	name = "\improper Skrellian holobadge"
	desc = "A high tech Skrellian holobadge, designed to project information about the owner."
	icon_state = "skrell_badge"
	badge_string = null	//Will be the name of the SDTF.

/obj/item/clothing/accessory/badge/tags/skrell/set_desc(var/mob/living/carbon/human/H)
	if(!istype(H))
		return
	desc = "Blood type: [H.b_type]"

/obj/item/clothing/accessory/badge/tags/skrell/verb/set_sdtf()
	set name = "Set SDTF Name"
	set category = "Object"
	set src in usr

	if(usr.incapacitated())
		to_chat(usr, "<span class='warning'>You're unable to do that.</span>")
		return

	var/obj/item/in_hand = usr.get_active_hand()
	if(in_hand != src)
		to_chat(usr, "<span class='warning'>You have to be holding [src] to modify it.</span>")
		return

	badge_string = sanitize(input(usr, "Input your SDTF.", "SDTF Holobadge") as null|text, MAX_NAME_LEN)

	if(usr.incapacitated())	//Because things can happen while you're typing
		to_chat(usr, "<span class='warning'>You're unable to do that.</span>")
		return
	in_hand = usr.get_active_hand()
	if(in_hand != src)
		to_chat(usr, "<span class='warning'>You have to be holding [src] to modify it.</span>")
		return

	if(badge_string)
		set_name(usr.real_name)
		set_desc(usr)
		verbs -= /obj/item/clothing/accessory/badge/tags/skrell/verb/set_sdtf

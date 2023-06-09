/obj/item/clothing/shoes/civilian
	name = "leather shoes"
	desc = "The best choice for haired assistants."
	icon = 'infinity/icons/obj/clothing/obj_feet.dmi'
	item_icons = list(slot_shoes_str = 'infinity/icons/mob/onmob/onmob_feet.dmi')
	icon_state = "leather_shoes"
	item_state = "leather_shoes"

/obj/item/clothing/shoes/civilian/white
	name = "white leather shoes"
	desc = "The best choice for flag officers."
	icon_state = "white_shoes"
	item_state = "white_shoes"

/obj/item/clothing/shoes/civilian/black
	name = "black leather shoes"
	desc = "The best choice for guys from the streets."
	icon_state = "black_shoes"
	item_state = "black_shoes"

/obj/item/clothing/shoes/workboots/alt
	name = "low workboots"
	icon_state = "workboots"
	item_state = "workboots"
	icon = 'infinity/icons/obj/clothing/obj_feet.dmi'
	item_icons = list(slot_shoes_str = 'infinity/icons/mob/onmob/onmob_feet.dmi')

/obj/item/clothing/shoes/combat/marine
	icon_state = "swat"
	armor = list(melee = 50, bullet = 50, laser = 30,energy = 25, bomb = 50, bio = 10, rad = 0)

/obj/item/clothing/shoes/anime_white
	name = "white shoes"
	desc = "Just a nice looking shoes."
	icon = 'infinity/icons/obj/clothing/obj_feet.dmi'
	item_icons = list(
		slot_shoes_str = 'infinity/icons/mob/onmob/onmob_feet.dmi',
		slot_r_hand_str = 'infinity/icons/mob/onmob/righthand.dmi',
		slot_l_hand_str = 'infinity/icons/mob/onmob/lefthand.dmi')
	icon_state = "anime_shoes_white"
	item_state = "anime_shoes_white"

/obj/item/clothing/shoes/anime_blue
	name = "blue shoes"
	desc = "Just a nice looking shoes."
	icon = 'infinity/icons/obj/clothing/obj_feet.dmi'
	item_icons = list(
		slot_shoes_str = 'infinity/icons/mob/onmob/onmob_feet.dmi',
		slot_r_hand_str = 'infinity/icons/mob/onmob/righthand.dmi',
		slot_l_hand_str = 'infinity/icons/mob/onmob/lefthand.dmi')
	icon_state = "anime_shoes_blue"
	item_state = "anime_shoes_blue"

/obj/item/clothing/shoes/cowboy
	name = "cowboy boots"
	desc = "Lacking a durasteel horse to ride."
	icon_state = "cowboy"
	item_state = "cowboy"
	icon = 'infinity/icons/obj/clothing/obj_feet.dmi'
	item_icons = list(slot_shoes_str = 'infinity/icons/mob/onmob/onmob_feet.dmi')

/obj/item/clothing/shoes/cowboy/classic
	name = "classic cowboy boots"
	desc = "A classic looking pair of durable cowboy boots."
	icon_state = "cowboy_classic"
	item_state = "cowboy_classic"

/obj/item/clothing/shoes/cowboy/snakeskin
	name = "snakeskin cowboy boots"
	desc = "A pair of cowboy boots made from python skin."
	icon_state = "cowboy_snakeskin"
	item_state = "cowboy_snakeskin"

/obj/item/clothing/shoes/taj_old_shoes
	desc = "An old pattern shoes made of blackened leather with greenish protector. Built to keep moisture out and prevent \"trench paw\". This ones are for cold winter periods and cover the whole feet."
	name = "vintage boots"
	icon_state = "taj_old_shoes"
	item_state = "taj_old_shoes"
	species_restricted = list(SPECIES_TAJARA)

/obj/item/clothing/shoes/taj_new_shoes
	desc = "A new pattern boots made of black leather with a slighly blueish tint. This ones quite ergonomic and not as encumbering as the old boots. Built to keep moisture out and prevent \"trench paw\". This ones are for cold winter periods and cover the whole feet."
	name = "military boots"
	icon_state = "taj_new_shoes"
	item_state = "taj_new_shoes"
	species_restricted = list(SPECIES_TAJARA)

/obj/item/clothing/shoes/taj_new_shoes_cut
	desc = "A new pattern boots made of black leather with a slighly blueish tint. This ones quite ergonomic and not as encumbering as the old boots. Light and toeless version for long distance marches!"
	name = "toeless military  boots"
	icon_state = "taj_new_shoes"
	item_state = "taj_new_shoes_cut"
	species_restricted = list(SPECIES_TAJARA)

/obj/item/clothing/shoes/taj_old_shoes_cut
	desc = "An old pattern shoes made of blackened leather with greenish protector. Built to withstand a lot of abuse during travel. This ones are for \"warmer\" and dry periods, good for hiking, good for toes."
	name = "toeless vintage boots"
	icon_state = "taj_old_shoes"
	item_state = "taj_old_shoes_cut"
	species_restricted = list(SPECIES_TAJARA)

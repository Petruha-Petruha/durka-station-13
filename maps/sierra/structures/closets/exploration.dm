/*
 * Sierra Exploration
 */

/* /decl/closet_appearance/secure_closet/sierra/exploration
	extra_decals = list(
		"stripe_vertical_mid_full" = COLOR_PURPLE,
		"exped" = COLOR_PURPLE
	)

/decl/closet_appearance/secure_closet/sierra/exploration/pilot
	extra_decals = list(
		"stripe_vertical_left_full" = COLOR_PURPLE,
		"stripe_vertical_right_full" = COLOR_PURPLE,
		"exped" = COLOR_PURPLE
	)

/decl/closet_appearance/secure_closet/sierra/exploration/leader
	extra_decals = list(
		"stripe_vertical_left_full" = COLOR_PURPLE,
		"stripe_vertical_mid_full" = COLOR_GOLD,
		"stripe_vertical_right_full" = COLOR_PURPLE,
		"exped" = COLOR_GOLD
	)
 */

/obj/structure/closet/secure_closet/el
	name = "exploration leader's locker"
	req_access = list(access_el)
	icon_state = "exp"
	icon_door = "el"

/obj/structure/closet/secure_closet/el/WillContain()
	return list(
		/obj/item/device/radio,
		/obj/item/device/tape/random,
		/obj/item/device/gps,
		/obj/item/pinpointer/radio,
		/obj/item/device/radio/beacon,
		/obj/item/taperoll/research,
		/obj/item/material/hatchet/machete/deluxe,
		/obj/item/storage/belt/holster/machete,
		/obj/item/device/spaceflare,
		/obj/item/clothing/accessory/storage/webbing_large,
		/obj/item/device/taperecorder,
		/obj/item/device/scanner/gas,
		/obj/item/device/flash,
		/obj/item/device/radio/headset/exploration_leader,
		/obj/item/device/radio/headset/exploration_leader/alt,
		/obj/item/storage/box/encryptionkey/exploration,
		/obj/item/device/binoculars,
		/obj/item/clothing/under/rank/field,
		/obj/item/clothing/under/rank/field/tan,
		/obj/item/clothing/under/rank/field/navy,
		/obj/item/clothing/under/rank/field/green,
		/obj/item/crowbar/prybar,
		new /datum/atom_creator/weighted(list(/obj/item/storage/backpack, /obj/item/storage/backpack/satchel/grey)),
		new /datum/atom_creator/weighted(list(/obj/item/storage/backpack/dufflebag, /obj/item/storage/backpack/messenger)),
		new /datum/atom_creator/weighted(list(/obj/item/device/flashlight/upgraded, /obj/item/device/flashlight/flare, /obj/item/device/flashlight/flare/glowstick/random))
	)

/obj/structure/closet/secure_closet/explorer
	name = "explorer's locker"
	req_access = list(access_explorer)
	icon_state = "exp"

/obj/structure/closet/secure_closet/explorer/WillContain()
	return list(
		/obj/item/device/radio,
		/obj/item/device/gps,
		/obj/item/taperoll/research,
		/obj/item/storage/belt/holster/machete,
		/obj/item/device/spaceflare,
		/obj/item/clothing/accessory/storage/webbing_large,
		/obj/item/device/scanner/gas,
		/obj/item/device/radio/headset/exploration,
		/obj/item/device/radio/headset/exploration/alt,
		/obj/item/device/binoculars,
		/obj/item/crowbar/prybar,
		new /datum/atom_creator/weighted(list(/obj/item/storage/backpack, /obj/item/storage/backpack/satchel/grey)),
		new /datum/atom_creator/weighted(list(/obj/item/storage/backpack/dufflebag, /obj/item/storage/backpack/messenger)),
		new /datum/atom_creator/weighted(list(/obj/item/device/flashlight, /obj/item/device/flashlight/flare, /obj/item/device/flashlight/flare/glowstick/random))
	)

/obj/structure/closet/secure_closet/explorer/pilot
	name = "expeditionary pilot's locker"
	req_access = list(access_explorer, list(access_el, access_expedition_shuttle_helm))
	icon_state = "exp"
	icon_door = "pilot"

/obj/structure/closet/secure_closet/explorer/pilot/WillContain()
	return list(
		/obj/item/device/radio,
		/obj/item/device/gps,
		/obj/item/storage/belt/utility/full,
		/obj/item/device/spaceflare,
		/obj/item/clothing/accessory/storage/holster/machete,
		/obj/item/clothing/accessory/storage/webbing_large,
		/obj/item/device/scanner/gas,
		/obj/item/device/radio/headset/headset_pilot/alt,
		/obj/item/device/binoculars,
		/obj/item/clothing/gloves/thick,
		/obj/item/clothing/suit/storage/toggle/track,
		/obj/item/clothing/head/helmet/nt/pilot,
		/obj/item/crowbar/prybar,
		new /datum/atom_creator/weighted(list(/obj/item/storage/backpack, /obj/item/storage/backpack/satchel/grey)),
		new /datum/atom_creator/weighted(list(/obj/item/storage/backpack/dufflebag, /obj/item/storage/backpack/messenger)),
		new /datum/atom_creator/weighted(list(/obj/item/device/flashlight, /obj/item/device/flashlight/flare, /obj/item/device/flashlight/flare/glowstick/random))
	)

/obj/structure/closet/secure_closet/explorer/medic
	name = "field medic's locker"
	req_access = list(access_explorer, list(access_el, access_field_med))

/obj/structure/closet/secure_closet/explorer/medic/WillContain()
	return list(
		/obj/item/device/radio,
		/obj/item/device/gps,
		/obj/item/storage/belt/medical/emt,
		/obj/item/device/spaceflare,
		/obj/item/clothing/accessory/storage/holster/machete,
		/obj/item/clothing/accessory/storage/webbing_large,
		/obj/item/device/scanner/gas,
		/obj/item/device/scanner/health,
		/obj/item/storage/firstaid/adv,
		/obj/item/device/radio/headset/exploration,
		/obj/item/device/radio/headset/exploration/alt,
		/obj/item/device/binoculars,
		/obj/item/clothing/gloves/thick,
		/obj/item/crowbar/prybar,
		new /datum/atom_creator/weighted(list(/obj/item/storage/backpack, /obj/item/storage/backpack/satchel/grey)),
		new /datum/atom_creator/weighted(list(/obj/item/storage/backpack/dufflebag, /obj/item/storage/backpack/messenger)),
		new /datum/atom_creator/weighted(list(/obj/item/device/flashlight, /obj/item/device/flashlight/flare, /obj/item/device/flashlight/flare/glowstick/random))
	)

/obj/structure/closet/secure_closet/explorer/engineer
	name = "field engineer's locker"
	req_access = list(access_explorer, list(access_el, access_field_eng))

/obj/structure/closet/secure_closet/explorer/engineer/WillContain()
	return list(
		/obj/item/device/radio,
		/obj/item/device/gps,
		/obj/item/storage/belt/utility/full,
		/obj/item/device/multitool,
		/obj/item/device/spaceflare,
		/obj/item/clothing/accessory/storage/holster/machete,
		/obj/item/clothing/accessory/storage/webbing_large,
		/obj/item/device/scanner/gas,
		/obj/item/device/robotanalyzer,
		/obj/item/device/flashlight/upgraded,
		/obj/item/combitool,
		/obj/item/device/radio/headset/exploration,
		/obj/item/device/radio/headset/exploration/alt,
		/obj/item/device/binoculars,
		/obj/item/clothing/gloves/thick,
		new /datum/atom_creator/weighted(list(/obj/item/storage/backpack, /obj/item/storage/backpack/satchel/grey)),
		new /datum/atom_creator/weighted(list(/obj/item/storage/backpack/dufflebag, /obj/item/storage/backpack/messenger)),
		new /datum/atom_creator/weighted(list(/obj/item/device/flashlight, /obj/item/device/flashlight/flare, /obj/item/device/flashlight/flare/glowstick/random))
	)

/obj/structure/closet/wardrobe/exploration
	name = "exploration wardrobe"
	desc = "It's a storage unit for standard-issue attire."
	closet_appearance = /decl/closet_appearance/wardrobe/pink

/obj/structure/closet/wardrobe/exploration/WillContain()
	return list(
		/obj/item/clothing/under/rank/field = 6,
		/obj/item/clothing/under/rank/field/tan = 6,
		/obj/item/clothing/under/rank/field/navy = 6,
		/obj/item/clothing/under/rank/field/green = 6
	)

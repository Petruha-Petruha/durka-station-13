/* Utility Closets
 * Contains:
 *		Emergency Closet
 *		Fire Closet
 *		Tool Closet
 *		Radiation Closet
 *		Bombsuit Closet
 *		Hydrant
 *		First Aid
 *		Excavation Closet Away Site
 *		Shipping Supplies Closet
 */

/*
 * Emergency Closet
 */
/obj/structure/closet/emcloset
	name = "emergency closet"
	desc = "It's a storage unit for emergency breathmasks and o2 tanks."
	icon_state = "emergency"

/obj/structure/closet/emcloset/WillContain()
	//Guaranteed kit
	. = list(/obj/item/tank/emergency/oxygen,
			/obj/item/clothing/mask/breath,
			/obj/item/storage/med_pouch/oxyloss = 2,
			/obj/item/clothing/suit/space/emergency,
			/obj/item/clothing/head/helmet/space/emergency)

	. += new/datum/atom_creator/simple(list(/obj/item/storage/toolbox/emergency, /obj/item/inflatable/wall = 2), 75)
	. += new/datum/atom_creator/simple(list(/obj/item/tank/emergency/oxygen/engi, /obj/item/clothing/mask/gas/half), 10)
	. += new/datum/atom_creator/simple(/obj/item/device/oxycandle, 15)
	. += new/datum/atom_creator/simple(/obj/item/storage/firstaid/o2, 25)

/obj/structure/closet/emcloset/full/WillContain()
	. = list(/obj/item/tank/emergency/oxygen,
			/obj/item/clothing/mask/breath,
			/obj/item/clothing/suit/space/emergency,
			/obj/item/clothing/head/helmet/space/emergency,
			/obj/item/storage/toolbox/emergency)

/*
 * Fire Closet
 */
/obj/structure/closet/walllocker/firecloset
	name = "fire-safety closet"
	desc = "It's a storage unit for fire-fighting supplies."
	icon_state = "fire"


/obj/structure/closet/walllocker/firecloset/WillContain()
	return list(
		/obj/item/storage/med_pouch/burn,
		/obj/item/storage/backpack/dufflebag/firefighter,
		/obj/item/clothing/mask/gas,
		/obj/item/device/flashlight
		)

/obj/structure/closet/walllocker/firecloset/chief

/obj/structure/closet/walllocker/firecloset/chief/WillContain()
	return list(
		/obj/item/storage/med_pouch/burn,
		/obj/item/clothing/suit/fire/firefighter,
		/obj/item/clothing/mask/gas,
		/obj/item/device/flashlight,
		/obj/item/tank/emergency/oxygen/double/red,
		/obj/item/extinguisher,
		/obj/item/clothing/head/hardhat/firefighter/Chief)

/*
 * Tool Closet
 */
/obj/structure/closet/toolcloset
	name = "tool closet"
	desc = "It's a storage unit for tools."
	icon_state = "eng"
	icon_door = "eng_tool"

/obj/structure/closet/toolcloset/New()
	..()
	if(prob(40))
		new /obj/item/clothing/suit/storage/hazardvest(src)
	if(prob(70))
		new /obj/item/device/flashlight(src)
	if(prob(70))
		new /obj/item/screwdriver(src)
	if(prob(70))
		new /obj/item/wrench(src)
	if(prob(70))
		new /obj/item/weldingtool(src)
	if(prob(70))
		new /obj/item/crowbar(src)
	if(prob(70))
		new /obj/item/wirecutters(src)
	if(prob(70))
		new /obj/item/device/t_scanner(src)
	if(prob(20))
		new /obj/item/storage/belt/utility(src)
	if(prob(30))
		new /obj/item/stack/cable_coil/random(src)
	if(prob(30))
		new /obj/item/stack/cable_coil/random(src)
	if(prob(30))
		new /obj/item/stack/cable_coil/random(src)
	if(prob(20))
		new /obj/item/device/multitool(src)
	if(prob(5))
		new /obj/item/clothing/gloves/insulated(src)
	if(prob(40))
		new /obj/item/clothing/head/hardhat(src)


/*
 * Radiation Closet
 */
/obj/structure/closet/radiation
	name = "radiation suit closet"
	desc = "It's a storage unit for rad-protective suits."
	icon_state = "eng"
	icon_door = "eng_rad"

/obj/structure/closet/radiation/WillContain()
	return list(
		/obj/item/storage/med_pouch/radiation = 2,
		/obj/item/clothing/suit/radiation,
		/obj/item/clothing/head/radiation,
		/obj/item/clothing/suit/radiation,
		/obj/item/clothing/head/radiation,
		/obj/item/device/geiger = 2)

/*
 * Bombsuit closet
 */
/obj/structure/closet/bombcloset
	name = "\improper EOD closet"
	desc = "It's a storage unit for explosion-protective suits."
	icon_state = "bomb"

/obj/structure/closet/bombcloset/WillContain()
	return list(
		/obj/item/clothing/suit/bomb_suit,
		/obj/item/clothing/under/color/black,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/head/bomb_hood)


/obj/structure/closet/bombclosetsecurity
	name = "\improper EOD closet"
	desc = "It's a storage unit for explosion-protective suits."
	icon_state = "bombsec"

/obj/structure/closet/bombclosetsecurity/WillContain()
	return list(
		/obj/item/clothing/suit/bomb_suit/security,
		/obj/item/clothing/under/rank/security,
		/obj/item/clothing/shoes/brown,
		/obj/item/clothing/head/bomb_hood/security)

/*
 * Hydrant
 */
/obj/structure/closet/hydrant
	name = "fire-safety closet"
	desc = "It's a storage unit for fire-fighting supplies."
	icon_state = "fire"
	anchored = TRUE
	density = TRUE
	storage_types = CLOSET_STORAGE_ITEMS | CLOSET_STORAGE_MOBS
	setup = 0

/obj/structure/closet/hydrant/WillContain()
	return list(
		/obj/item/inflatable/door = 2,
		/obj/item/storage/med_pouch/burn = 2,
		/obj/item/clothing/mask/gas/half,
		/obj/item/storage/backpack/dufflebag/firefighter
		)

/*
 * First Aid
 */
/obj/structure/closet/medical_wall //wall mounted medical closet
	name = "first-aid closet"
	desc = "It's a wall-mounted storage unit for first aid supplies."
	icon_state = "medical_wall"
	anchored = TRUE
	density = FALSE
	wall_mounted = TRUE
	storage_types = CLOSET_STORAGE_ITEMS
	setup = 0

/obj/structure/closet/walllocker/medical/filled/WillContain()
	return list(
		/obj/random/firstaid,
		/obj/random/medical/lite = 12)

/obj/structure/closet/toolcloset/excavation/awaysite //no teleport beacons
	name = "excavation equipment closet"
	desc = "It's a storage unit for excavation equipment."
	closet_appearance = /decl/closet_appearance/secure_closet/engineering/tools

/obj/structure/closet/toolcloset/excavation/awaysite/WillContain()
	return list(
		/obj/item/storage/belt/archaeology,
		/obj/item/storage/excavation,
		/obj/item/device/flashlight/lantern,
		/obj/item/device/ano_scanner,
		/obj/item/device/depth_scanner,
		/obj/item/device/core_sampler,
		/obj/item/device/gps,
		/obj/item/pinpointer/radio,
		/obj/item/clothing/glasses/meson,
		/obj/item/clothing/glasses/science,
		/obj/item/pickaxe,
		/obj/item/device/measuring_tape,
		/obj/item/pickaxe/xeno/hand,
		/obj/item/storage/bag/fossils,
		/obj/item/hand_labeler,
		/obj/item/device/spaceflare
	)

/obj/structure/closet/walllocker/shipping_wall
	name = "shipping supplies closet"
	desc = "It's a wall-mounted storage unit containing supplies for preparing shipments."
	closet_appearance = /decl/closet_appearance/wall/shipping
	anchored = TRUE
	density = FALSE
	wall_mounted = TRUE
	storage_types = CLOSET_STORAGE_ITEMS
	setup = 0

/obj/structure/closet/walllocker/shipping_wall/filled/WillContain()
	return list(
		/obj/item/stack/material/cardboard/ten,
		/obj/item/device/destTagger,
		/obj/item/stack/package_wrap/twenty_five)

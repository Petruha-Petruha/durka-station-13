/obj/structure/closet/l3closet
	name = "level-3 biohazard suit closet"
	desc = "It's a storage unit for level-3 biohazard gear."
	icon_state = "bio"

/obj/structure/closet/l3closet/general/WillContain()
	return list(
		/obj/item/clothing/suit/bio_suit/general,
		/obj/item/clothing/head/bio_hood/general,
		/obj/item/clothing/mask/gas/half,
		/obj/item/tank/emergency/oxygen/engi,
	)

/obj/structure/closet/l3closet/general/multi/WillContain()
	return MERGE_ASSOCS_WITH_NUM_VALUES(..(), list(
		/obj/item/clothing/head/bio_hood/general = 3, //inf was 5,
		/obj/item/clothing/mask/gas/half = 3, //inf was 5,
		/obj/item/clothing/suit/bio_suit/general = 3, //inf was 5,
		/obj/item/tank/emergency/oxygen/engi = 3, //inf was 5,
	))


/obj/structure/closet/l3closet/virology
	icon_state = "bio_viro"

/obj/structure/closet/l3closet/virology/WillContain()
	return list(
		/obj/item/clothing/suit/bio_suit/virology,
		/obj/item/clothing/head/bio_hood/virology,
		/obj/item/clothing/mask/gas,
		/obj/item/tank/oxygen
	)

/obj/structure/closet/l3closet/security
	icon_state = "bio_sec"

/obj/structure/closet/l3closet/security/WillContain()
	return list(
		/obj/item/clothing/suit/bio_suit/security,
		/obj/item/clothing/head/bio_hood/security,
		/obj/item/clothing/mask/gas/half,
		/obj/item/tank/emergency/oxygen/engi
	)

/obj/structure/closet/l3closet/janitor
	icon_state = "bio_jan"

/obj/structure/closet/l3closet/janitor/WillContain()
	return list(
		/obj/item/clothing/suit/bio_suit/janitor,
		/obj/item/clothing/head/bio_hood/janitor,
		/obj/item/clothing/mask/gas/half,
		/obj/item/tank/emergency/oxygen/engi
	)

/obj/structure/closet/l3closet/scientist
	icon_state = "bio_scientist"


/obj/structure/closet/l3closet/scientist/WillContain()
	return list(
		/obj/item/clothing/suit/bio_suit/scientist,
		/obj/item/clothing/head/bio_hood/scientist,
		/obj/item/clothing/mask/gas,
		/obj/item/tank/emergency/oxygen/double,
	)

/obj/structure/closet/l3closet/scientist/multi/WillContain()
	return MERGE_ASSOCS_WITH_NUM_VALUES(..(), list(
		/obj/item/clothing/head/bio_hood/scientist = 5,
		/obj/item/clothing/suit/bio_suit/scientist = 5,
		/obj/item/clothing/mask/gas = 5,
		/obj/item/tank/emergency/oxygen/double = 5,
	))

/obj/structure/closet/l3closet/command
	icon_state = "bio_sec"


/obj/structure/closet/l3closet/command/WillContain()
	return list(
		/obj/item/clothing/suit/bio_suit/cmo,
		/obj/item/clothing/head/bio_hood/cmo,
		/obj/item/clothing/mask/gas/half,
		/obj/item/tank/emergency/oxygen/engi
	)

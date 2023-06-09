#include "merchant_areas.dm"

/obj/effect/overmap/visitable/ship/merchant
	name = "Merchant vessel"
	scanner_name = "Merchant vessel"
	scanner_desc = @{"[i]Registration[/i]: FTU #$$#%^#$
[i]Class[/i]: Small ship
[i]Transponder[/i]: CIV
[b]Notice[/b]: Sensor array is detecting a small vessel with merchant identifier"}
	color = "#ffc966"
	vessel_mass = 50
	default_delay = 35 SECONDS
/*
	initial_restricted_waypoints = list(
		"Aquila" = list("nav_merchant_aquila")
	)

	initial_generic_waypoints = list(
		"nav_merchant_1",
		"nav_merchant_2",
		"nav_merchant_3",
		"nav_merchant_antag"
	)

/datum/map_template/ruin/away_site/merchant
	name = "Merchant"
	id = "awaysite_merchant"
	description = "Small vessel with merchpad."
	suffixes = list("merchant/merchant-1.dmm", "merchant/merchant-2.dmm")
	spawn_cost = 1000 //Event?
*/
/obj/effect/shuttle_landmark/nav_merchant/nav1
	name = "Merchant Navpoint #1"
	landmark_tag = "nav_merchant_1"

/obj/effect/shuttle_landmark/nav_merchant/nav2
	name = "Merchant Navpoint #2"
	landmark_tag = "nav_merchant_2"

/obj/effect/shuttle_landmark/nav_merchant/nav3
	name = "Merchant Navpoint #3"
	landmark_tag = "nav_merchant_3"

/obj/effect/shuttle_landmark/nav_merchant/aquila
	name = "Merchant Navpoint Aquila Dock"
	landmark_tag = "nav_merchant_aquila"

/obj/effect/shuttle_landmark/nav_merchant/nav4
	name = "Merchant Navpoint #4"
	landmark_tag = "nav_merchant_antag"

/var/const/access_zeppelin = "ACCESS_ZEPPELIN"//301
/datum/access/zeppelin
	id = access_zeppelin
	desc = "ITV Zeppelin"
	region = ACCESS_REGION_GENERAL
	access_type = ACCESS_TYPE_NONE

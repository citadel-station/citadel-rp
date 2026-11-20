//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/obj/map_helper/access_helper
	icon = 'icons/mapping/helpers/access_helpers.dmi'

/obj/map_helper/access_helper/Initialize(mapload)
	run_access_mod()
	return ..()

/obj/map_helper/access_helper/proc/run_access_mod()
	return

/obj/map_helper/access_helper/auto
	icon_state = "auto"

	/// string key to use when looking up access during a dmm_context load.
	var/lookup_key
	/// fallback to default access if lookup_key isn't found.
	/// * if this is FALSE, we instead do nothing.
	var/allow_fallback = TRUE

/**
 * @return /datum/access_defaults instance or null
 */
/obj/map_helper/access_helper/auto/proc/detect_access()
	return get_area(src)?.get_default_access(src.lookup_key)

/**
 * Automatically binds everything in our turf to our map's access.
 * * This is a very blunt tool, as it sets everything on its tile.
 *
 * Currently supported:
 * * Airlocks
 * * APCs
 * * Closets & Crates
 */
/obj/map_helper/access_helper/auto/trample_everything

/obj/map_helper/access_helper/auto/trample_everything/run_access_mod()
	// more complex things will be harder but most entities are trivial
	var/list/obj/trivial_detections = list()

	for(var/obj/checking in loc)
		if(istype(checking, /obj/machinery/door))
			trivial_detections += checking
		else if(istype(checking, /obj/machinery/apc))
			trivial_detections += checking
		else if(istype(checking, /obj/machinery/air_alarm))
			trivial_detections += checking
		else if(istype(checking, /obj/structure/closet))
			trivial_detections += checking
		else if(istype(checking, /obj/machinery/button))
			trivial_detections += checking

	if(!length(trivial_detections))
		return

	// this may be a list or a single value
	var/datum/access_defaults/detected = detect_access()

	if(!detected)
		for(var/obj/overwriting as anything in trivial_detections)
			overwriting.req_access = overwriting.req_one_access = null
	else
		for(var/obj/overwriting as anything in trivial_detections)
			overwriting.req_access = detected.req_access
			overwriting.req_one_access = detected.req_one_access

/obj/map_helper/access_helper/auto/generic

/obj/map_helper/access_helper/auto/generic/staff
	lookup_key = ACCESS_DEFAULTS_LOOKUP_KEY_STAFF

/obj/map_helper/access_helper/auto/generic/maintenance
	lookup_key = ACCESS_DEFAULTS_LOOKUP_KEY_MAINTENANCE

/obj/map_helper/access_helper/auto/generic/public
	lookup_key = ACCESS_DEFAULTS_LOOKUP_KEY_PUBLIC

/obj/map_helper/access_helper/auto/generic/command
	lookup_key = ACCESS_DEFAULTS_LOOKUP_KEY_COMMAND

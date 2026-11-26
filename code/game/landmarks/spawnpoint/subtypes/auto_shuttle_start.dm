//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * Starting point for instanced role shuttles.
 * * Specifically used for dynamic role spawns that spawn in their own shuttles / maps / whatnot.
 * * Having more than one on a shuttle **hints** to the game that it should
 *   allow that many people to instance in on the shuttle. The game is free to ignore this.
 */
/obj/landmark/spawnpoint/auto_shuttle_start
	var/datum/shuttle/bound

/obj/landmark/spawnpoint/auto_shuttle_start/Initialize(mapload)
	. = ..()
	if(. == INITIALIZE_HINT_QDEL)
		return

	recheck_bound()

/obj/landmark/spawnpoint/auto_shuttle_start/Register()
	SHOULD_CALL_PARENT(FALSE)
	if(bound)
		LAZYINITLIST(bound.auto_spawnpoints)
		bound.auto_spawnpoints += src

	#warn impl

/obj/landmark/spawnpoint/auto_shuttle_start/Unregister()
	SHOULD_CALL_PARENT(FALSE)
	if(bound)
		bound.auto_spawnpoints -= src

	#warn impl

/obj/landmark/spawnpoint/auto_shuttle_start/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change)
	..()
	if(loc != old_loc)
		recheck_bound()

/obj/landmark/spawnpoint/auto_shuttle_start/proc/recheck_bound()
	var/turf/our_turf = get_turf(src)
	var/area/our_area = our_turf?.loc

	var/datum/shuttle/new_shuttle

	if(!istype(our_area, /area/shuttle))
		new_shuttle = null
	else
		var/area/shuttle/our_casted_area = our_area
		new_shuttle = our_casted_area.shuttle

	if(bound != new_shuttle)
		Unregister()
		bound = new_shuttle
		Register()

/obj/landmark/spawnpoint/auto_shuttle_start/proc/is_still_valid()
	return is_valid_turf(get_turf(src))

/obj/landmark/spawnpoint/auto_shuttle_start/proc/is_valid_turf(turf/T)
	var/area/found = T?.loc

	if(!istype(found, /area/shuttle))
		return FALSE

	var/area/shuttle/casted = found
	return casted == src.bound

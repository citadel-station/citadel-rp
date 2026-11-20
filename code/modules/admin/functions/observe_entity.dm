//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * Immediately adminghost and start orbiting / observing a target.
 */
/datum/admins/proc/observe_entity(atom/target)
	if(!istype(target))
		return FALSE

	var/turf/target_turf = get_turf(target)
	if(!target_turf)
		return FALSE

	teleport_as_ghost_to_loc(target_turf)

	if(!ismovable(target))
		return TRUE

	var/mob/observer/dead/our_observer = owner.mob
	if(!istype(our_observer))
		return TRUE

	our_observer.ManualFollow(target)
	return TRUE

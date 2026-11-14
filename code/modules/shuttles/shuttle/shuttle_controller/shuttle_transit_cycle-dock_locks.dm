//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/datum/shuttle_transit_cycle/proc/add_dock_lock(obj/shuttle_dock/target)
	if(target in dock_locks)
		return FALSE
	return target.attempt_dock_lock(src)

/datum/shuttle_transit_cycle/proc/remove_dock_locks()
	for(var/obj/shuttle_dock/target as anything in dock_locks)
		remove_dock_lock(target)

/datum/shuttle_transit_cycle/proc/remove_dock_lock(obj/shuttle_dock/target)
	if(target.locked_by_transit != src)
		return FALSE

	target.remove_transit_lock()
	return TRUE

/datum/shuttle_transit_cycle/proc/has_dock_lock(obj/shuttle_dock/target)
	return target in dock_locks

/**
 * Called when a dock forcefully drops the lock we placed on it.
 * * Not called when we remove_dock_lock(); only called if the dock calls
 *   drop_dock_lock(). The purpose of this is to communicate
 *   so that the transit cycle can automatically fail if a dock
 *   is somehow deleted.
 */
/datum/shuttle_transit_cycle/proc/on_dock_lock_dropped(obj/shuttle_dock/target)
	// TODO: stage may need to be informed? how do we cancel?

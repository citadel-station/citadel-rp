//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * Attempt to lock the shuttle dock for a transit cycle.
 */
/obj/shuttle_dock/proc/lock_for_transit(datum/shuttle_transit_cycle/transit)
	if(locked_by_transit)
		return FALSE
	LAZYADD(transit.dock_locks, src)
	locked_by_transit = transit
	return TRUE

/**
 * Forcefully drop a transit lock, if any.
 * @return the transit cycle that held the lock, or null if there was none.
 */
/obj/shuttle_dock/proc/drop_transit_lock()
	if(!locked_by_transit)
		return null

	var/datum/shuttle_transit_cycle/old_transit = _remove_transit_lock()
	. = old_transit
	if(old_transit)
		old_transit.on_dock_lock_dropped(src)

/**
 * Silently removes transit lock.
 * * Please don't use this directly; use drop_transit_lock().
 *   This is used internally to clean up the lock without triggering callbacks.
 */
/obj/shuttle_dock/proc/remove_transit_lock()
	LAZYREMOVE(locked_by_transit.dock_locks, src)
	. = locked_by_transit
	locked_by_transit = null

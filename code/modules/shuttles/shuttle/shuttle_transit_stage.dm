//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * A transit stage is a specific phase of a shuttle's transit cycle.
 * * These are the 'states' of the state machine; yes, the states are stateful.
 *   That's not usually a good thing but whatever.
 *
 * ## Lifecycle
 *
 * Lifecycle is as follows.
 * * `New(cycle)`
 * * `setup()`
 * * `tick()` until done
 * * `cleanup()`
 */

/datum/shuttle_transit_stage
	/// owning cycle
	var/datum/shuttle_transit_cycle/cycle

	#warn below
	/// stage enum
	var/stage = SHUTTLE_TRANSIT_STAGE_IDLE
	/**
	 * List of blockers
	 */
	var/list/datum/shuttle_operation_blocker/blockers
	/// attempt to ignore blockers
	var/forcing = FALSE
	/// attempt to ignore blockers that could be dangerous to ignore (hanger doors, point defense, etc)
	var/dangerously_forcing = FALSE

	/// timeout set on us
	/// * this isn't actually enforced on our side; it's enforced on the shuttle controller's side.
	var/timeout_duration
	/// world.time we will time out on
	var/timeout_at

#warn impl all
/datum/shuttle_transit_stage/New(datum/shuttle_transit_cycle/cycle)

/datum/shuttle_transit_stage/proc/setup()
	SHOULD_NOT_SLEEP(TRUE)

/**
 * @return Time until next poll, or 'null' to drop from polling.
 */
/datum/shuttle_transit_stage/proc/tick()
	SHOULD_NOT_SLEEP(TRUE)

	// By default, stages do not request further polling
	// and will not tick.

	return null

/datum/shuttle_transit_stage/proc/cleanup()
	SHOULD_NOT_SLEEP(TRUE)

/**
 * Supertype of all standard transit stages.
 *
 * * Standard stages are that which transits
 *   a shuttle from one location to another; this should be
 *   compatible with normal docks like ferries, web-maps,
 *   escape pods, and overmap shuttles.
 *
 * ## Failure Handling
 *
 * This has standard handling for 'easy' abort situations,
 * like a target dock breaking. You may set an abort handler
 * to do this, so that overmaps shuttles can return to the overmap.
 */
/datum/shuttle_transit_stage/standard
	abstract_type = /datum/shuttle_transit_stage/standard

/datum/shuttle_transit_stage/standard/undock_from_origin

/datum/shuttle_transit_stage/standard/takeoff_from_origin

/datum/shuttle_transit_stage/standard/transiting_towards_destination

/datum/shuttle_transit_stage/standard/land_at_destination

/datum/shuttle_transit_stage/standard/dock_at_destination


#warn impl


/**
 * implies [force()]
 */
// /datum/event_args/shuttle/proc/dangerously_force()
// 	force()
// 	if(dangerously_forcing)
// 		return
// 	dangerously_forcing = TRUE
// 	#warn impl

// /datum/event_args/shuttle/proc/finish(success)
// 	succeeded = success
// 	finished = TRUE

// 	for(var/datum/shuttle_hook/hook in waiting_on_hooks)
// 		release(hook)

// /datum/event_args/shuttle/proc/block(datum/shuttle_hook/hook, list/reason_or_reasons, dangerous)
// 	. = FALSE
// 	if(!blockable)
// 		// it is YOUR job to check if an event is blockable.
// 		CRASH("attempted to block an unblockable event")
// 	ASSERT(!(src in hook.blocking))
// 	LAZYADD(hook.blocking, src)
// 	waiting_on_hooks[hook] = islist(reason_or_reasons)? reason_or_reasons : list(reason_or_reasons)
// 	if(dangerous)
// 		forcing_could_be_dangerous = TRUE
// 	return TRUE

// /datum/event_args/shuttle/proc/release(datum/shuttle_hook/hook)
// 	waiting_on_hooks -= hook
// 	LAZYREMOVE(hook.blocking, src)

// /datum/event_args/shuttle/proc/update(datum/shuttle_hook/hook, list/reason_or_reasons)
// 	waiting_on_hooks[hook] = islist(reason_or_reasons)? reason_or_reasons : list(reason_or_reasons)

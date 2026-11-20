//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

//* Transit - Access *//

/**
 * Get transit stage
 */
/datum/shuttle_controller/proc/get_transit_stage()
	if(isnull(transit_cycle))
		return SHUTTLE_TRANSIT_STAGE_IDLE
	return transit_cycle.stage

/**
 * gets world.time time (so, deciseconds) left in transit
 *
 * * negative values can be returned if we're overdue, somehow!
 * * return null if we're not in transit
 * * having a transit cycle isn't the same as being in transit.
 */
/datum/shuttle_controller/proc/get_transit_time_left()
	#warn impl

//* Transit - Configuration *//

/**
 * default transit time
 *
 * @params
 * * towards_dock - the dock we want to fly to; optional
 */
/datum/shuttle_controller/proc/default_transit_time(obj/shuttle_dock/towards_dock)
	return transit_time_default

/**
 * default spool-up/takeoff time
 *
 * @params
 * * from_dock - the dock we want to take off from; optional
 */
/datum/shuttle_controller/proc/default_takeoff_time(obj/shuttle_dock/from_dock)
	return takeoff_time_default

//* Transit - Main *//

/**
 * begin a transit cycle
 *
 * * this is a very low level proc. you should know what you're doing before doing this.
 */
/datum/shuttle_controller/proc/run_transit_cycle(datum/shuttle_transit_cycle/cycle)
	SHOULD_NOT_SLEEP(TRUE)
	run_transit_cycle_impl(cycle)

/**
 * internal proc; do not use
 */
/datum/shuttle_controller/proc/run_transit_cycle_impl(datum/shuttle_transit_cycle/cycle)
	SHOULD_NOT_SLEEP(TRUE)
	PRIVATE_PROC(TRUE)
	// clean up anything left
	var/redirected = FALSE
	if(transit_cycle)
		terminate_transit(SHUTTLE_TRANSIT_STATUS_REDIRECTED)
		redirected = TRUE
	// initialize & start
	cycle.initialize(src)
	cycle.start(redirected)

/**
 * immediate transit towards a specific dock
 *
 * * immediately jumps us into transit space, or the target dock
 * * all docking / traversal events are marked as force-on-fail with a hard timeout equal to [jump_time]
 * * this means if anything takes longer than that it's immediately forced past.
 * * this does not flag the transit as DO_NOT_INTERRUPT, so if [transit_time] isn't instant the user can abort this!
 * * mostly a helper proc
 * * in-progress transits are terminated and the new transit immediately starts.
 */
/datum/shuttle_controller/proc/perform_immediate_transit(
	obj/shuttle_dock/dock,
	obj/shuttle_aligner/port/align_with_port,
	centered,
	direction,
	transit_flags,
	list/datum/callback/on_transit_callbacks,
	traversal_flags_source = NONE,
	traversal_flags_target = NONE,
	transit_time = 0,
	jump_time = 0,
)
	traversal_flags_source |= SHUTTLE_TRAVERSAL_FLAGS_FORCE_ON_FAIL
	traversal_flags_target |= SHUTTLE_TRAVERSAL_FLAGS_FORCE_ON_FAIL
	return transit_towards_dock(
		dock,
		align_with_port,
		centered,
		direction,
		transit_flags,
		on_transit_callbacks,
		traversal_flags_source,
		traversal_flags_target,
		transit_time = transit_time,
		jump_time = jump_time,
	)

/**
 * normal transit cycle towards a specific dock.
 *
 * * in-progress transits are terminated and the new transit immediately starts.
 */
/datum/shuttle_controller/proc/transit_towards_dock(
	obj/shuttle_dock/dock,
	obj/shuttle_aligner/port/align_with_port,
	centered,
	direction,
	transit_flags,
	list/datum/callback/on_transit_callbacks,
	traversal_flags_source,
	traversal_flags_target,
	dock_timeout,
	traversal_timeout,
	transit_time,
	jump_time,
)
	var/datum/shuttle_transit_cycle/cycle = new(
		dock,
		align_with_port,
		centered,
		direction,
		transit_flags,
		on_transit_callbacks,
		traversal_flags_source,
		traversal_flags_target,
		dock_timeout,
		traversal_timeout,
		transit_time,
		jump_time,
	)
	cycle.set_transit_flags(transit_flags)
	cycle.set_source_traversal_flags(traversal_flags_source)
	cycle.set_target_traversal_flags(traversal_flags_target)
	return run_transit_cycle(cycle)

/**
 * abort an in progress transit cycle gracefully
 *
 * @return TRUE if either successful or transit doesn't exist; FALSE if failed / too late to abort
 */
/datum/shuttle_controller/proc/asynchronously_abort_transit()
	SHOULD_NOT_SLEEP(TRUE)
	return transit_cycle?.abort() || FALSE

/**
 * aborts an in progress transit cycle gracefully
 *
 * blocks on the cycle aborting
 *
 * @return TRUE if either successful or transit doesn't exist; FALSE if failed / too late to abort
 */
/datum/shuttle_controller/proc/synchronously_abort_transit()
	var/datum/shuttle_transit_cycle/in_progress = transit_cycle
	. = transit_cycle?.abort() || FALSE
	if(!.)
		return
	UNTIL(in_progress != transit_cycle)

/**
 * immediately terminates an in progress transit cycle. asynchronous.
 */
/datum/shuttle_controller/proc/terminate_transit()
	SHOULD_NOT_SLEEP(TRUE)
	transit_cycle?.terminate()

//* Transit - Hooks *//

/**
 * called on transit begin by the cycle
 *
 * @params
 * * cycle - the transit cycle
 * * redirected - this is from us getting another transit_towards_dock while transiting
 */
/datum/shuttle_controller/proc/on_transit_begin(datum/shuttle_transit_cycle/cycle, redirected)
	SHOULD_NOT_SLEEP(TRUE)

/**
 * called on transit termination by the cycle
 *
 * @params
 * * cycle - the transit cycle
 * * status - transit status
 */
/datum/shuttle_controller/proc/on_transit_end(datum/shuttle_transit_cycle/cycle, status)
	SHOULD_NOT_SLEEP(TRUE)

/**
 * registers a callback to be fired when transit ends
 *
 * @params
 * * cb - a callback or a list of callbacks
 *
 * @return FALSE if we're not in transit
 */
/datum/shuttle_controller/proc/register_transit_callback(datum/callback/cb)
	if(!get_transit_stage())
		return FALSE
	transit_cycle.finish_callbacks += cb
	return TRUE

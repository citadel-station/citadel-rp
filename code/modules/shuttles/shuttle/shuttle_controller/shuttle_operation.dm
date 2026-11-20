//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * stateful operations for shuttle controllers
 */
/datum/shuttle_operation
	/// the controller we're executing on. set on init.
	var/datum/shuttle_controller/controller
	/// unique operation ID. set by the controller on init.
	var/id

	/// blockers currently active, if any
	var/list/datum/shuttle_operation_blocker/blockers = list()

	/// is forcing
	var/forcing = FALSE
	/// is dangerously forcing, if forcing
	var/dangerously_forcing = FALSE

	/// disallow players from interrupting
	/// * this is best understood as a 'strong suggestion'.
	///   there's a million ways to bypass this, unfortunately.
	var/disallow_interrupt = FALSE

	/// callbacks to be called with (src, status)
	/// * these will not be called if we are deleted.
	var/list/datum/callback/on_finish_callbacks
	/// current status
	var/status = SHUTTLE_OPERATION_STATUS_RUNNING

	#warn impl
	/// timeout set on us
	/// * this isn't actually enforced on our side; it's enforced on the shuttle controller's side.
	var/timeout_duration
	/// world.time we will time out on
	var/timeout_at

/datum/shuttle_operation/proc/Initialize(datum/shuttle_controller/controller)
	src.controller = controller

/datum/shuttle_operation/Destroy()
	QDEL_LIST(blockers)
	on_finish = null
	controller = null
	return ..()

/**
 * Returns UI describe list.
 * @return list(
 *  "name" = "OUR NAME",
 * )
 */
/datum/shuttle_operation/proc/ui_serialize()
	var/list/serialized_blockers = list()
	for(var/datum/shuttle_operation_blocker/blocker as anything in src.blockers)
		serialized_blockers += blocker.ui_serialize()

	return list(
		"name" = "Operating",
		"blockers" = serialized_blockers,
	)

/**
 * Register an on-finish callback.
 * @return FALSE if already finished.
 */
/datum/shuttle_operation/proc/register_finish_callback(datum/callback/on_finish)
	if(src.status != SHUTTLE_OPERATION_STATUS_RUNNING)
		return FALSE
	LAZYADD(src.on_finish_callbacks, on_finish)

/datum/shuttle_operation/proc/get_status()
	return src.status

/datum/shuttle_operation/proc/finish(status)
	if(src.status != SHUTTLE_OPERATION_STATUS_RUNNING)
		return FALSE
	if(status == SHUTTLE_OPERATION_STATUS_RUNNING)
		return FALSE
	src.status = status
	src.on_finish(status)
	return TRUE

/**
 * Called when entering operation.
 */
/datum/shuttle_operation/proc/setup()
	SHOULD_NOT_SLEEP(TRUE)

/**
 * * This may delete ourselves as if we finish the controller usually deletes us.
 * @return time to next check
 */
/datum/shuttle_operation/proc/poll()
	SHOULD_NOT_SLEEP(TRUE)

	if(length(blockers))
		// var/
		#warn ok not only do we need to force/whatnot, blockers need to be told they were terminated / forced if needed :|
		return
	src.finish(SHUTTLE_OPERATION_STATUS_SUCCESS)

/**
 * Called when exiting operation.
 * * Called before on_finish(status).
 */
/datum/shuttle_operation/proc/cleanup()
	SHOULD_NOT_SLEEP(TRUE)

/datum/shuttle_operation/proc/on_finish(status)
	SHOULD_NOT_SLEEP(TRUE)

	for(var/datum/callback/on_finish as anything in src.on_finish_callbacks)
		on_finish.InvokeAsync(src, status)

#warn below

/datum/shuttle_operation/proc/force()
	#warn impl

/datum/shuttle_operation/proc/dangerously_force()
	#warn impl

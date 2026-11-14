//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/datum/shuttle_controller/proc/is_currently_in_operation(operation_id)
	return operation != null && (!operation_id || (operation.id == operation_id))

/**
 * @return null on fail, or operation on success
 */
/datum/shuttle_controller/proc/start_operation(path, ...)
	if(is_currently_in_operation())
		return null
	if(!ispath(path, /datum/shuttle_operation))
		CRASH("Invalid path for shuttle operation")

	var/datum/shuttle_operation/operation = new path(arglist(...))
	#warn impl

/**
 * @param operation - the operation to run
 * @param on_finish - (optional) callback(s) to invoke when the operation finishes
 * @param timeout - (optional) max time allowed for the operation
 * @details `on_finish` may be called immediately if the operation exits on begin.
 * @return operation id, or null on fail
 */
/datum/shuttle_controller/proc/run_operation(datum/shuttle_operation/operation, datum/callback/on_finish, timeout)

	if(operation.controller)
		CRASH("operation is already part of another controller")

	operation.controller = src

	#warn impl

/**
 * @return null if not current operation, or status on finish
 */
/datum/shuttle_controller/proc/block_on_operation(operation_id)
	#warn impl


//* Docking - Main *//

/**
 * * returns existing op id if already docking
 * * interrupts undocking automatically
 *
 * @params
 * * on_finish - a callback or a list of callbacks to call when the docking / undocking cycle ends
 * * no_interrupt - nicely suggests we shouldn't be interrupted. this doesn't actually make sure we aren't interrupted.
 * * timeout - don't let the op take longer than this
 *
 * @return op id
 */
/datum/shuttle_controller/proc/asynchronously_dock(datum/callback/on_finish, no_interrupt, timeout)
	switch(docking_state)
		if(SHUTTLE_DOCKING_STATE_DOCKING)
			on_docking(on_finish, docking_cycle)
			return docking_cycle
	. = docking_cycle
	INVOKE_ASYNC(src, PROC_REF(synchronously_dock), no_interrupt, on_finish, timeout)
	// we assume that the interruption / beginning of a new cycle ffwill only increment by 1.
	if(. != docking_cycle - 1)
		stack_trace("unexpected behavior - docking cycle incremented by more than 1. a core assumption made when writing this code was violated.")
	. = docking_cycle

/**
 * * returns existing op id if already undocking
 * * interrupts docking automatically
 *
 * @params
 * * on_finish - a callback or a list of callbacks to call when the docking / undocking cycle ends
 * * no_interrupt - nicely suggests we shouldn't be interrupted. this doesn't actually make sure we aren't interrupted.
 * * timeout - don't let the op take longer than this
 *
 * @return op id
 */
/datum/shuttle_controller/proc/asynchronously_undock(datum/callback/on_finish, no_interrupt, timeout)
	switch(docking_state)
		if(SHUTTLE_DOCKING_STATE_UNDOCKING)
			on_docking(on_finish, docking_cycle)
			return docking_cycle
	. = docking_cycle
	INVOKE_ASYNC(src, PROC_REF(synchronously_undock), no_interrupt, on_finish, timeout)
	// we assume that the interruption / beginning of a new cycle will only increment by 1.
	if(. != docking_cycle - 1)
		stack_trace("unexpected behavior - docking cycle incremented by more than 1. a core assumption made when writing this code was violated.")
	. = docking_cycle

/**
 * immediately interrupt docking
 */
/datum/shuttle_controller/proc/interrupt_docking()
	if(docking_state != SHUTTLE_DOCKING_STATE_DOCKING)
		return
	++docking_cycle

/**
 * immediately interrupt docking
 */
/datum/shuttle_controller/proc/interrupt_undocking()
	if(docking_state != SHUTTLE_DOCKING_STATE_UNDOCKING)
		return
	++docking_cycle

/**
 * * returns existing op id if already docking
 * * interrupts undocking automatically
 *
 * @params
 * * no_interrupt - nicely suggests we shouldn't be interrupted. this doesn't actually make sure we aren't interrupted.
 * * initial_callbacks - initial list of callbacks to invoke on finish. can be a single callback or a list.
 * * timeout - max time allowed.
 *
 * @return SHUTTLE_DOCKING_STATUS_*
 */
/datum/shuttle_controller/proc/synchronously_dock(no_interrupt, list/datum/callback/initial_callbacks, timeout = 60 SECONDS)
	// we should only increase cycle by 1
	#warn impl

/**
 * * returns existing op id if already undocking
 * * interrupts docking automatically	// wait for cycle to end or for us to not be in a docking state

 *
 * @params
 * * no_interrupt - nicely suggests we shouldn't be interrupted. this doesn't actually make sure we aren't interrupted.
 * * initial_callbacks - initial list of callbacks to invoke on finish. can be a single callback or a list.
 * * timeout - max time allowed.
 *
 * @return SHUTTLE_DOCKING_STATUS_*
 */
/datum/shuttle_controller/proc/synchronously_undock(no_interrupt, list/datum/callback/initial_callbacks, timeout = 60 SECONDS)
	// we should only increase cycle by 1
	#warn impl

/**
 * block on a docking op
 *
 * * if cycle isn't present, we will immediately succeed if docking passes
 * * if cycle isn't present, we will immediately fail if we are not either docking or docked
 * * if cycle is present, we will return STATUS_EXPIRED if it passed, as we cannot know if the original cycle is the reason for success / fail.
 *
 * note: we can only return STATUS_SUCCESS, STATUS_FAILE, and STATUS_EXPIRED.
 *       ABORTED, TIMEOUT, and INVALID will never be fired from this because
 *       we don't have the information embedded in our variables.
 *
 * @params
 * * cycle - the operation id
 *
 * @return SHUTTLE_DOCKING_STATUS_*
 */
/datum/shuttle_controller/proc/block_on_docking(cycle)
	// ensure right cycle if there is one set
	if(cycle && (docking_cycle != cycle))
		return SHUTTLE_DOCKING_STATUS_EXPIRED
	// if already docked, succeed. if not docked or dockign, fail.
	switch(docking_state)
		if(SHUTTLE_DOCKING_STATE_DOCKED)
			return SHUTTLE_DOCKING_STATUS_SUCCESS
		if(SHUTTLE_DOCKING_STATE_DOCKING)
		else
			return SHUTTLE_DOCKING_STATUS_FAILED
	// wait for cycle to end or for us to not be in a docking state
	while((!cycle || (docking_cycle == cycle)) && (docking_state == SHUTTLE_DOCKING_STATE_DOCKING))
		stoplag(1)
	// if cycle is wrong, exit
	if(cycle && (docking_cycle != cycle))
		return SHUTTLE_DOCKING_STATUS_EXPIRED
	// ensure we are docked
	return docking_state == SHUTTLE_DOCKING_STATE_DOCKING? SHUTTLE_DOCKING_STATUS_SUCCESS : SHUTTLE_DOCKING_STATUS_FAILED

/**
 * block on an undocking op
 *
 * * if cycle isn't present, we will immediately succeed if undocking passes
 * * if cycle isn't present, we will immediately fail if we are not either undocking or undocked
 * * if cycle is present, we will return STATUS_EXPIRED if it passed, as we cannot know if the original cycle is the reason for success / fail.
 *
 * note: we can only return STATUS_SUCCESS, STATUS_FAILE, and STATUS_EXPIRED.
 *       ABORTED, TIMEOUT, and INVALID will never be fired from this because
 *       we don't have the information embedded in our variables.
 *
 * @params
 * * cycle - the operation id
 *
 * @return SHUTTLE_DOCKING_STATUS_*
 */
/datum/shuttle_controller/proc/block_on_undocking(cycle)
	// ensure right cycle if there is one set
	if(cycle && (docking_cycle != cycle))
		return SHUTTLE_DOCKING_STATUS_EXPIRED
	// if already docked, succeed. if not docked or dockign, fail.
	switch(docking_state)
		if(SHUTTLE_DOCKING_STATE_DOCKED)
			return SHUTTLE_DOCKING_STATUS_SUCCESS
		if(SHUTTLE_DOCKING_STATE_DOCKING)
		else
			return SHUTTLE_DOCKING_STATUS_FAILED
	// wait for cycle to end or for us to not be in a docking state
	while((!cycle || (docking_cycle == cycle)) && (docking_state == SHUTTLE_DOCKING_STATE_DOCKING))
		stoplag(1)
	// if cycle is wrong, exit
	if(cycle && (docking_cycle != cycle))
		return SHUTTLE_DOCKING_STATUS_EXPIRED
	// ensure we are docked
	return docking_state == SHUTTLE_DOCKING_STATE_DOCKING? SHUTTLE_DOCKING_STATUS_SUCCESS : SHUTTLE_DOCKING_STATUS_FAILED

/**
 * register a callback to fire on docking completion
 *
 * * if cycle isn't present, we will immediately succeed if docking passes
 * * if cycle isn't present, we will immediately fail if we are not either docking or docked
 * * if cycle is present, we will return STATUS_EXPIRED if it passed, as we cannot know if the original cycle is the reason for success / fail.
 * * otherwise, behavior will be the same as if this callback was registered during the beginning of the cycle
 *
 * @params
 * * callback - what to call
 * * cycle - the operation id to filter by, if any
 */
/datum/shuttle_controller/proc/on_docking(datum/callback/callback, cycle)
	// ensure right cycle if there is one set
	if(cycle && (docking_cycle != cycle))
		callback.InvokeAsync(src, SHUTTLE_DOCKING_STATUS_EXPIRED, null)
	// if already docked, succeed. if not docked or dockign, fail.
	switch(docking_state)
		if(SHUTTLE_DOCKING_STATE_DOCKED)
			callback.InvokeAsync(src, SHUTTLE_DOCKING_STATUS_SUCCESS, SHUTTLE_DOCKING_STATE_DOCKING)
			return
		if(SHUTTLE_DOCKING_STATE_DOCKING)
		else
			callback.InvokeAsync(src, SHUTTLE_DOCKING_STATUS_FAILED, SHUTTLE_DOCKING_STATE_DOCKING)
			return
	// we are currently docking and on the right cycle. add us to the callbacks list.
	docking_callbacks += callback

/**
 * register a callback to fire on undocking completion
 *
 * * if cycle isn't present, we will immediately succeed if undocking passes
 * * if cycle isn't present, we will immediately fail if we are not either undocking or undocked
 * * if cycle is present, we will return STATUS_EXPIRED if it passed, as we cannot know if the original cycle is the reason for success / fail.
 * * otherwise, behavior will be the same as if this callback was registered during the beginning of the cycle
 *
 * @params
 * * callback - what to call
 * * cycle - the operation id to filter by, if any
 */
/datum/shuttle_controller/proc/on_undocking(datum/callback/callback, cycle)
	// ensure right cycle if there is one set
	if(cycle && (docking_cycle != cycle))
		callback.InvokeAsync(src, SHUTTLE_DOCKING_STATUS_EXPIRED, null)
	// if already undocked, succeed. if not undocked or undocking, fail.
	switch(docking_state)
		if(SHUTTLE_DOCKING_STATE_UNDOCKED)
			callback.InvokeAsync(src, SHUTTLE_DOCKING_STATUS_SUCCESS, SHUTTLE_DOCKING_STATE_UNDOCKING)
			return
		if(SHUTTLE_DOCKING_STATE_UNDOCKING)
		else
			callback.InvokeAsync(src, SHUTTLE_DOCKING_STATUS_FAILED, SHUTTLE_DOCKING_STATE_UNDOCKING)
			return
	// we are currently docking and on the right cycle. add us to the callbacks list.
	docking_callbacks += callback

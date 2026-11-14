//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * Shuttle controller
 *
 * Acts like a TGUI module.
 */
/datum/shuttle_controller
	//* Intrinsics *//
	/// our host shuttle
	var/datum/shuttle/shuttle

	//* Operation *//
	/**
	 * Active operation, if any
	 */
	var/datum/shuttle_operation/operation
	/// Next operation ID
	var/operation_id_next = 0

	//* Docking - Control *//
	/// stored docking codes
	var/list/docking_codes
	/// dock UIDs we always have codes for
	var/list/docking_always_has_code_to_ids

	//* Docking - State *//
	/// docking state
	var/docking_state = SHUTTLE_DOCKING_STATE_UNKNOWN

	//* Manual Landing *//
	/// current manual landing dock
	var/obj/shuttle_dock/manual_dock
	/**
	 * /datum/shuttle_docker instances by user.
	 * * 'User' here refers to the 'initiator' of an actor-performer event_args;
	 *   ergo the one actually using the UI.
	 */
	var/list/datum/shuttle_docker/docker_by_user

	//* Transit *//
	/// in-progress transit
	var/datum/shuttle_transit_cycle/transit_cycle
	/// default transit time
	var/transit_time_default = 10 SECONDS
	/// default takeoff time
	var/takeoff_time_default = 5 SECONDS

	//* UI *//
	/// tgui interface to load
	#warn is this for admin uis or
	var/tgui_module

/datum/shuttle_controller/Destroy()
	terminate_transit()
	interrupt_operation()
	QDEL_LIST_ASSOC_VAL(docker_by_user)
	QDEL_NULL(manual_dock)

	if(shuttle)
		if(shuttle.controller == src)
			shuttle.controller = null
		shuttle = null

	return ..()

/datum/shuttle_controller/proc/initialize(datum/shuttle/shuttle)
	. = FALSE
	ASSERT(!src.shuttle)

	src.shuttle = shuttle
	return TRUE

//* Location *//

/**
 * Get the approximate Z-index our shuttle's on.
 *
 * @return z-index or 0 or null
 */
/datum/shuttle_controller/proc/get_current_z_index()
	return shuttle.anchor.z

//* Interface *//

/datum/shuttle_controller/ui_data(mob/user, datum/tgui/ui)
	. = ..()
	// general output; dynamic output
	// set in your ui_date().
	.["dynamicGeneralOutput"] = null
	// dynamic output for 'why the shuttle cannot go'
	// this will gray out launch buttons and provide hover text for why you can't launch
	// this does not actually enforce this, so, make sure you block launch yourself too
	.["dynamicWhyCannotLaunch"] = null

/datum/shuttle_controller/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()
	.["$src"] = REF(src)
	.["$tgui"] = tgui_module

/datum/shuttle_controller/proc/tgui_act(action, list/params, authorization)
	#warn impl

/datum/shuttle_controller/proc/tgui_push(list/data)
	// this is just a wrapper so we can change it later if need be
	return push_ui_data(data = data)

/datum/shuttle_controller/proc/push_ui_location()
	#warn uh oh
	return

//* Interface - Authorization *//

/// Specifications for 'actor'
///
/// * Actor must always be the person who accesses the UI that's then checking this
/// * Actor should be null if something is logically 'abstracted' enough that an actor isn't directly controlling the shuttle / interfacing with it

/// Specifications for 'endpoint'
///
/// todo: < control columns aren't actually implemented yet, this is just here so we know what to do when they are. >
///
/// * Shuttle control consoles return themselves
/// * Overmap control consoles return the control column they're accessing the shuttle with
/// * Shuttle / Overmaps control augments return the control column they're accessing the shuttle with
/// * Admin panels return the admin holder (/datum/holder) that they belong to / are being called from

/**
 * checks if a user with a given set of flags should be allowed to abort the current transit cycle
 *
 * * you are responsible for checking transit stage
 *
 * @params
 * * authorization - SHUTTLE_AUTHORIZATION_* flags
 * * actor - actor tuple; optional
 * * endpoint - the accessing control source; e.g. an overmaps column, a shuttle console, or an admin holder
 *
 * @return TRUE if we are allowed to toss the current transit cycle
 */
/datum/shuttle_controller/proc/check_auth_abort_transit(authorization, datum/event_args/actor/actor, datum/endpoint)
	return !!(authorization & SHUTTLE_AUTHORIZATION_ABORT)

/**
 * checks if a user with a given set of flags should be allowed to force the shuttle to depart
 *
 * @params
 * * authorization - SHUTTLE_AUTHORIZATION_* flags
 * * actor - actor tuple; optional
 * * endpoint - the accessing control source; e.g. an overmaps column, a shuttle console, or an admin holder
 *
 * @return NONE | SHUTTLE_AUTHORIZE_TO_SOFT_FORCE | SHUTTLE_AUTHORIZE_TO_HARD_FORCE
 */
/datum/shuttle_controller/proc/check_auth_force_launch(authorization, datum/event_args/actor/actor, datum/endpoint)
	. = NONE
	if(authorization & SHUTTLE_AUTHORIZATION_FORCE)
		. |= SHUTTLE_AUTHORIZED_TO_SOFT_FORCE
	if(authorization & SHUTTLE_AUTHORIZATION_DANGEROUSLY_FORCE)
		. |= SHUTTLE_AUTHORIZED_TO_HARD_FORCE

/**
 * checks if a user with a given set of flags should be allowed to perform manual landing
 *
 * * anchor_turf, anchor_direction is only needed when someone is attempting to finalize a landing operation
 * * they will not be provided for checking if someone should be allowed to launch a shuttle docker
 *
 * @params
 * * authorization - SHUTTLE_AUTHORIZATION_* flags
 * * actor - actor tuple; optional
 * * endpoint - the accessing control source; e.g. an overmaps column, a shuttle console, or an admin holder
 * * anchor_turf - where the anchor will be
 * * anchor_direction - the direction the anchor (and therefoer shuttle) will be
 *
 * @return NONE | SHUTTLE_AUTHORIZED_TO_DESIGNATE_MANUAL_LANDING | SHUTTLE_AUTHORIZED_TO_MANUAL_LAND_THERE
 */
/datum/shuttle_controller/proc/check_auth_manual_landing(authorization, datum/event_args/actor/actor, datum/endpoint)
	if(authorization & SHUTTLE_AUTHORIZATION_LAND)
		return SHUTTLE_AUTHORIZED_TO_DESIGNATE_MANUAL_LANDING | SHUTTLE_AUTHORIZED_TO_MANUAL_LAND_THERE
	return NONE

//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * Creates a manual landing docker UI that captures the user's camera.
 */
/datum/shuttle_controller/proc/create_manual_landing_docker_and_capture(datum/event_args/actor/actor, datum/host)
	new /datum/shuttle_docker(shuttle, host, actor.initiator, CALLBACK(src, PROC_REF(user_set_manual_landing)))

/datum/shuttle_controller/proc/user_set_manual_landing(turf/where, dir, mob/user, datum/shuttle_docker/docker)

/**
 * call to designate a manual landing position
 *
 * this is unchecked / has no safety checks.
 *
 * @return FALSE on failure
 */
/datum/shuttle_controller/proc/set_manual_landing(turf/anchor_target_location, anchor_target_orientation)
	if(!isnull(manual_dock))
		QDEL_NULL(manual_dock)

	#warn impl
	#warn interrupt in-progress moves

/**
 * returns a list of name-to-turf of valid jump points on a given zlevel
 * * these should be centered, ideally
 * * level center and dock with manual_docking_beacon are included by shuttle docker
 *   automatically and may be ignored by this proc.
 */
/datum/shuttle_controller/proc/manual_landing_beacons(zlevel)
	. = list()

/**
 * returns a list of valid name-to-zlevel-index for manual landing
 */
/datum/shuttle_controller/proc/manual_landing_levels()
	. = list()

//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * Shuttle custom docking handler
 * * Always provides alignment via the master (anchor) aligner.
 */
/datum/shuttle_docker
	/// our host shuttle
	var/datum/shuttle/shuttle
	/// host datum, if any. this is usually the datum the user is interacting with, like a console
	/// or an admin panel.
	var/datum/host

	/// our current eye
	/// * its dir is our dir
	var/atom/movable/render/shuttle_docker/eye

	/// the actor initiating this
	var/datum/event_args/actor/actor

	/// used perspective
	var/datum/perspective/used_perspective

	/**
	 * Called when the user attempts to designate a location for docking.
	 *
	 * * Called with (turf/anchor_location, dir, datum/event_args/actor/actor, datum/shuttle_docker/docker)
	 *
	 * Return FALSE to forbid landing.
	 */
	#warn call
	var/datum/callback/on_target

	/**
	 * Called to get jump points for manual landing.
	 *
	 * * Called with (datum/event_args/actor/actor, datum/shuttle_docker/docker)
	 *
	 * Return a list("name" = turf) of valid jump points.
	 */
	#warn call
	var/datum/callback/on_jump_query

	var/datum/action/shuttle_docker/designate/action_for_designate
	var/datum/action/shuttle_docker/exit/action_for_exit
	#warn this
	var/datum/action/shuttle_docker/jump/action_for_jump

	var/designate_in_progress = FALSE
	var/designate_time = 5 SECONDS

	var/image/current_manual_position_render

/datum/shuttle_docker/New(datum/shuttle/shuttle, datum/host, mob/user, datum/callback/on_target, datum/callback/on_jump_query)
	src.shuttle = shuttle
	src.host = host
	src.on_target = on_target
	src.on_jump_query = on_jump_query

	create_eye()
	used_perspective = new
	setup_perspective()
	capture_user(user)

/datum/shuttle_docker/Destroy()
	if(user)
		release_user()
	on_target = null
	position = null
	host = null
	shuttle = null
	QDEL_NULL(used_perspective)
	QDEL_NULL(current_manual_position_render)
	return ..()

/datum/shuttle_docker/proc/create_eye()
	src.eye = new(shuttle.anchor.loc)
	src.eye.dir = shuttle.anchor.dir
	src.eye.vis_contents += shuttle.get_preview()

/datum/shuttle_docker/proc/update_current_manual_position(turf/where, dir)
	if(current_manual_position_render)
		used_perspective.remove_image(current_manual_position_render)
		QDEL_NULL(current_manual_position_render)

	if(!where)
		return

	current_manual_position_render = image(shuttle.get_preview(), where, dir = dir)
	used_perspective.add_image(current_manual_position_render)

/datum/shuttle_docker/proc/capture_user(mob/user)
	#warn impl

/datum/shuttle_docker/proc/release_user()
	#warn impl

/datum/shuttle_docker/proc/set_position(turf/position, dir = eye.dir)
	eye.forceMove(position)
	if(dir != eye.dir)
		eye.setDir(dir)

/datum/shuttle_docker/proc/setup_perspective()
	used_perspective.set_eye(eye)

	var/atom/movable/screen/plane_master/plane

	plane = used_perspective.planes.by_plane_type(
		/atom/movable/screen/plane_master/objs,
	)
	plane.alpha = 0

	plane = used_perspective.planes.by_plane_type(
		/atom/movable/screen/plane_master/mobs,
	)
	plane.alpha = 0

	used_perspective.SetSight(SEE_TURFS | SEE_SELF)

	used_perspective.see_in_dark = 14
	used_perspective.update_see_in_dark()

/datum/shuttle_docker/proc/attempt_designate(turf/target, dir, datum/event_args/actor/actor)
	var/success = TRUE

	designate_in_progress = TRUE

	if(!do_self(actor.initiator, designate_time, DO_AFTER_IGNORE_ACTIVE_ITEM | DO_AFTER_IGNORE_MOVEMENT, NONE, progress_anchor = target))
		success = FALSE

	designate_in_progress = FALSE

	if(!success)
		return

	on_target(target, dir, actor, src)

/datum/action/shuttle_docker
	target_type = /datum/shuttle_docker

/datum/action/shuttle_docker/invoke_target(datum/shuttle_docker/target, datum/event_args/actor/actor)
	return ..()

/datum/action/shuttle_docker/designate
	name = "Designate"
	desc = "Attempt to designate the current location as the manual docking beacon"
	#warn icon

/datum/action/shuttle_docker/designate/invoke_target(datum/shuttle_docker/target, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return TRUE
	var/turf/target_turf = get_turf(target.eye)
	if(!target_turf)
		return TRUE
	var/dir = target.eye.dir
	return target.attempt_designate(target_turf, dir, actor)

/datum/action/shuttle_docker/exit
	name = "Exit"
	desc = "Exit manual docking interface."
	#warn icon

/datum/action/shuttle_docker/exit/invoke_target(datum/shuttle_docker/target, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return TRUE
	qdel(target)
	return TRUE

/datum/action/shuttle_docker/jump
	name = "Jump To Beacon"
	desc = "Jump to a designated beacon on a given level"
	#warn icon

/datum/action/shuttle_docker/jump/invoke_target(datum/shuttle_docker/target, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return TRUE

	#warn impl

	return TRUE

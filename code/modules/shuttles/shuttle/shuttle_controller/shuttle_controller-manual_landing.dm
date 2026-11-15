//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * Creates a manual landing docker UI that captures the user's camera.
 */
/datum/shuttle_controller/proc/create_manual_landing_docker_and_capture(datum/event_args/actor/actor, datum/host)
	new /datum/shuttle_docker(
		shuttle,
		host,
		actor.initiator,
		CALLBACK(src, PROC_REF(user_set_manual_landing)),
		CALLBACK(src, PROC_REF(on_manual_landing_query)),
	)

/datum/shuttle_controller/proc/user_set_manual_landing(turf/where, dir, mob/user, datum/shuttle_docker/docker)
	#warn handle

/**
 * call to designate a manual landing position
 *
 * this is unchecked / has no safety checks.
 *
 * @return FALSE on failure
 */
/datum/shuttle_controller/proc/set_manual_landing(turf/anchor_target_location, anchor_target_orientation)
	. = FALSE

	if(!isnull(manual_dock))
		QDEL_NULL(manual_dock)

	var/obj/shuttle_dock/dock = new /obj/shuttle_dock/ephemeral/manual(
		anchor_target_location,
		null,
		anchor_target_orientation,
	)

	src.manual_dock = dock

	return TRUE

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
 * @return list() of destinations (empty allowed)
 */
/datum/shuttle_controller/proc/manual_landing_levels()
	return list()

/**
 * Check if manual landing is allowed.
 */
/datum/shuttle_controller/proc/manual_landing_allowed()
	return FALSE

/**
 * Returns a list of name-to-turf of valid jump points
 */
/datum/shuttle_controller/proc/on_manual_landing_query()
	RETURN_TYPE(/list)
	. = list()

	for(var/zlevel in src.manual_landing_levels())
		var/level_name = \
			SSmapping.level_get_fluff_name(z) || \
			SSmapping.level_get_fluff_id(z) || \
			SSmapping.level_get_name(z) || \
			SSmapping.level_get_id(z)

		.["[level_name]"] = locate(floor(world.maxx * 0.5), floor(world.maxy * 0.5), zlevel)

		for(var/obj/shuttle_dock/dock as anything in SSshuttle.docks_by_level[zlevel])
			var/i = 0
			if(!dock.manual_docking_beacon)
				continue
			if(.[dock.display_name])
				while(.["[level_name] - [dock.display_name] [++i]"])J
					continue
				.["[level_name] - [dock.display_name] [++i]"] = dock
			else
				.["[level_name] - [dock.display_name]"] = get_turf(dock)

		var/list/name_to_turf = src.manual_landing_beacons(zlevel)
		for(var/name in name_to_turf)
			.["[level_name] - [name]"] = name_to_turf[name]

//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * Used to render a specific thing, and everything around it, in a secondary view.
 * * This binds to *clients*, not *perspectives.* This binds to
 *   the real client of a using-mob.
 */
/datum/secondary_map
	var/map_id

	#warn impl both
	/**
	 * From map_popups.dm in rendering/legacy.
	 */
	var/atom/movable/screen/map_view/map_holder
	/**
	 * From map_popups.dm in rendering/legacy.
	 */
	var/atom/movable/screen/background/map_background
	/**
	 * List of users.
	 */
	var/list/client/clients
	/**
	 * Our planes.
	 */
	var/datum/plane_holder/tgui_camera/planes

/datum/secondary_map/New(map_id)
	src.map_id = map_id
	src.map_holder = new
	src.map_background = new
	src.planes = new(src.map_id)

/datum/secondary_map/Destroy()
	for(var/client/C in clients)
		revoke_from_client(C)

	QDEL_NULL(map_holder)
	QDEL_NULL(map_background)
	QDEL_NULL(planes)
	return ..()

/datum/secondary_map/proc/update_view()
	var/list/data = get_relevant_turfs()
	var/width = data[1]
	var/height = data[2]
	var/align_x = data[3]
	var/align_y = data[4]
	var/list/turf/turfs = data[5]

	map_background.screen_loc = "[map_id]:1,1 to [width],[height]"
	map_holder.screen_loc = "[map_id]:[1 + align_x],[1 + align_y]"

	#warn impl

/**
 * * Must return a strucutred list for perf reasons.
 * @return list(width, height, align x, align y, list(turfs...))
 */
/datum/secondary_map/proc/get_relevant_turfs() as /list
	return list(0, 0, 0, 0, list())

/datum/secondary_map/proc/grant_to_client(client/granting)
	if(granting in clients)
		CRASH("Client already has this secondary map.")
	LAZYADD(clients, granting)
	LAZYADD(granting.secondary_maps, src)

	granting.screen += map_holder
	granting.screen += map_background

	planes.apply(granting)

/datum/secondary_map/proc/revoke_from_client(client/revoking)
	LAZYREMOVE(clients, revoking)
	LAZYREMOVE(revoking.secondary_maps, src)

	granting.screen -= map_holder
	granting.screen -= map_background

	planes.remove(revoking)

/**
 * A secondary map that follows an atom around, showing everything around it in a radius.
 */
/datum/secondary_map/follow_entity_with_radius
	var/atom/movable/entity
	var/radius = 2
	var/move_queued = FALSE

/datum/secondary_map/follow_entity_with_radius/New(map_id, atom/movable/entity, radius)
	..()
	if(!isnull(radius))
		src.radius = radius
	if(!isnull(entity))
		src.set_entity(entity)

/datum/secondary_map/follow_entity_with_radius/Destroy()
	unset_entity()
	return ..()

/datum/secondary_map/follow_entity_with_radius/get_relevant_turfs()
	var/turf/entity_turf = get_turf(entity)
	if(!entity_turf)
		return list()
	var/use_radius = radius

	. =  RANGE_TURFS(use_radius, entity_turf)
	. = list(use_radius, use_radius, 0, 0 relevant_turfs)

/datum/secondary_map/follow_entity_with_radius/proc/on_entity_moved()
	if(move_queued)
		return
	queue_update()

/datum/secondary_map/follow_entity_with_radius/proc/queue_update()
	if(move_queued)
		return
	move_queued = TRUE
	// TODO: maybe subsystem?
	addtimer(CALLBACK(src, PROC_REF(update_queued)), 0)

/datum/secondary_map/follow_entity_with_radius/proc/update_queued()
	move_queued = FALSE
	update_view()

/datum/secondary_map/follow_entity_with_radius/proc/on_entity_del(datum/source)
	if(source == entity)
		unset_entity()

/datum/secondary_map/follow_entity_with_radius/proc/set_entity(atom/movable/new_entity)
	if(entity)
		unset_entity()
	if(!new_entity)
		return
	RegisterSignal(new_entity, COMSIG_PARENT_QDELETING, PROC_REF(on_entity_del))
	RegisterSignal(new_entity, COMSIG_MOVABLE_MOVED, PROC_REF(on_entity_moved))
	entity = new_entity
	update_view()

/datum/secondary_map/follow_entity_with_radius/proc/unset_entity()
	if(!entity)
		return
	UnregisterSignal(entity, list(COMSIG_PARENT_QDELETING, COMSIG_MOVABLE_MOVED))
	entity = null
	update_view()

/datum/secondary_map/follow_entity_with_radius/proc/set_radius(new_radius)
	radius = new_radius
	update_view()

/**
 * Renders an entire shuttle, centered on the shuttle itself.
 */
/datum/secondary_map/render_entire_shuttle
	var/border_radius = 3
	var/datum/shuttle/target
	var/update_queued = FALSE

/datum/secondary_map/render_entire_shuttle/New(map_id, datum/shuttle/target, border_radius)
	..()
	if(!isnull(border_radius))
		src.border_radius = border_radius
	if(!isnull(target))
		src.set_target(target)

/datum/secondary_map/render_entire_shuttle/Destroy()
	unset_target()
	return ..()

/datum/secondary_map/render_entire_shuttle/get_relevant_turfs()
	if(!target)
		return list(0, 0, 0, 0, list())
	#warn impl

/datum/secondary_map/render_entire_shuttle/proc/on_target_anchor_moved()
	queue_update()

/datum/secondary_map/render_entire_shuttle/proc/queue_update()
	if(update_queued)
		return
	update_queued = TRUE
	addtimer(CALLBACK(src, PROC_REF(update_queued)))

/datum/secondary_map/render_entire_shuttle/proc/update_queued()
	update_queued = FALSE
	update_view()

/datum/secondary_map/render_entire_shuttle/proc/on_target_del(datum/source)
	if(source == target)
		unset_target()

/datum/secondary_map/render_entire_shuttle/proc/set_target(datum/shuttle/new_target)
	if(target)
		unset_target()
	if(!new_target)
		return
	RegisterSignal(new_target, COMSIG_QDELETING, PROC_REF(on_target_del))
	target = new_target
	if(target.anchor)
		RegisterSignal(target.anchor, COMSIG_SHUTTLE_ANCHOR_MOVED, PROC_REF(on_target_anchor_moved))
	update_view()

/datum/secondary_map/render_entire_shuttle/proc/unset_target()
	if(!target)
		return
	UnregisterSignal(target, list(COMSIG_QDELETING, COMSIG_SHUTTLE_ANCHOR_MOVED))
	if(target.anchor)
		UnregisterSignal(target.anchor, COMSIG_SHUTTLE_ANCHOR_MOVED)
	target = null
	update_view()

/datum/secondary_map/render_entire_shuttle/proc/set_border_radius(new_radius)
	border_radius = new_radius
	update_view()

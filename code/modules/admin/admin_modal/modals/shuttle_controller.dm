//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/admin_modal/shuttle_controller
	var/datum/shuttle/target
	var/datum/secondary_map/render_entire_shuttle/target_renderer

	var/datum/shuttle_docker/yank_docker

/datum/admin_modal/shuttle_controller/Preload()
	modal_registered_key = "shuttle_controller-[REF(target)]"
	..()

/datum/admin_modal/shuttle_controller/Initialize(datum/shuttle/target)
	if(!istype(target))
		return FALSE
	RegisterSignal(target, COMSIG_QDELETING, PROC_REF(on_target_del))
	src.target = target
	for(var/datum/admin_modal/shuttle_controller/other in owner.admin_modals)
		if(other == src)
			continue
		if(other.target == src.target)
			return FALSE
	target_renderer = new /datum/secondary_map/render_entire_shuttle(target)
	return TRUE

/datum/admin_modal/shuttle_controller/Destroy()
	QDEL_NULL(yank_docker)
	QDEL_NULL(target_renderer)
	target = null
	return ..()

/datum/admin_modal/shuttle_controller/on_target_del()
	qdel(src)

#warn ui

/datum/admin_modal/shuttle_controller/on_ui_open(mob/user, datum/tgui/ui, embedded)
	. = ..()
	target_renderer?.grant_to_user(user)

/datum/admin_modal/shuttle_controller/on_ui_close(mob/user, datum/tgui/ui, embedded)
	. = ..()
	target_renderer?.revoke_from_user(user)

/datum/admin_modal/shuttle_controller/ui_data(mob/user, datum/tgui/ui)
	. = ..()
	#warn impl

/datum/admin_modal/shuttle_controller/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()
	.["name"] = target.name
	.["mapRef"] = target_renderer?.map_id
	#warn impl

/datum/admin_modal/shuttle_controller/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return

	var/datum/admins/admin_holder = usr.client.holder

	if(istype(target.controller, /datum/shuttle_controller/overmap))
		var/datum/shuttle_controller/overmap/overmap_controller = target.controller
		switch(action)
			if("openOvermapController")
				admin_holder.open_admin_modal(/datum/admin_modal/overmap_controller, overmap_controller)
				return TRUE
			if("yankToOvermapHere")

	#warn impl

	switch(action)
		if("beginYank")
			#warn impl
		if("anchorYank")
			#warn impl
		if("cancelYank")
			#warn impl
		if("confirmYank")
			REMOVE_TRAIT(target, TRAIT_SHUTTLE_INTERNED, ADMIN_TRAIT)
			#warn impl
			return TRUE
		if("dockAt")
			REMOVE_TRAIT(target, TRAIT_SHUTTLE_INTERNED, ADMIN_TRAIT)
			#warn impl
			return TRUE
		if("internment")
			// athena, the tireless one
			target.immediately_jump_to_transit()
			ADD_TRAIT(target, TRAIT_SHUTTLE_INTERNED, ADMIN_TRAIT)
			return TRUE
		if("releaseInternment")
		if("obliterate")
			// TODO: an 'obliterateConfirm' box
			//       that force you to acknowledge everything important being deleted.

			var/turf/where_they_were = target.anchor

			var/log_string = "[key_name(usr)] annihilated [target], which was currently \
			anchored at [AREACOORD(where_they_were)]."
			log_game(log_string)
			log_admin(log_string)
			message_admins(SPAN_ADMIN(log_string))

			target.dangerously_annihilate_this_shuttle()
			return TRUE
		if("narrate")
			admin_holder.open_admin_modal(/datum/admin_modal/admin_narrate, target)
			return TRUE

#warn impl

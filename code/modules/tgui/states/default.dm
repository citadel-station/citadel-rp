/**
 *! Copyright (c) 2020 Aleksej Komarov
 *! SPDX-License-Identifier: MIT
 */

/**
 * tgui state: default_state
 *
 * Checks a number of things -- mostly physical distance for humans
 * and view for robots.
 */

// TODO: ughhhhhh check the logic on this and define what this even semantically means
GLOBAL_DATUM_INIT(default_state, /datum/ui_state/default, new)

/datum/ui_state/default/can_use_topic(src_object, mob/user)
	// Call the individual mob-overridden procs.
	return min(user.default_can_use_topic(src_object), default_ui_status(user))

// TODO: rename this to 'default_ui_status_for' this isn't a 'topic' check anymore.
//       Also heavily consider moving overrides to the respective mobs.
/mob/proc/default_can_use_topic(src_object)
	return UI_CLOSE // Don't allow interaction by default.

/mob/living/default_can_use_topic(src_object)
	. = shared_ui_interaction(src_object)
	if(. > UI_CLOSE && loc) //must not be in nullspace.
		. = min(., shared_living_ui_distance(src_object)) // Check the distance...
	if(. == UI_INTERACTIVE && !IsAdvancedToolUser()) // Non-human living mobs can only look, not touch.
		return UI_UPDATE

/mob/living/silicon/robot/default_can_use_topic(src_object)
	. = shared_ui_interaction(src_object)
	if(. <= UI_DISABLED)
		return

	// Robots can interact with anything they can see.
	// todo: in view range for zooming
	if(get_dist(src, src_object) <= min(CEILING(client.current_viewport_width / 2, 1), CEILING(client.current_viewport_height / 2, 1)))
		return UI_INTERACTIVE
	return UI_DISABLED // Otherwise they can keep the UI open.

/mob/living/silicon/ai/default_can_use_topic(src_object)
	. = shared_ui_interaction(src_object)
	if(. != UI_INTERACTIVE)
		return

	// Make sure it's in the same map
	var/turf/src_turf = get_turf(src_object)
	var/turf/our_turf = get_turf(src)
	var/datum/map_level/src_level = src_turf && SSmapping.ordered_levels[src_turf.z]
	var/datum/map_level/our_level = our_turf && SSmapping.ordered_levels[our_turf.z]
	if(!src_level || (src_level.parent_map != our_level.parent_map))
		return FALSE

	// If an object is in view then we can interact with it
	if(src_object in view(client.view, src))
		return UI_INTERACTIVE

	// If we're installed in a chassi, rather than transfered to an inteliCard or other container, then check if we have camera view
	if(is_in_chassis())
		//stop AIs from leaving windows open and using then after they lose vision
		if(GLOB.cameranet && !GLOB.cameranet.checkTurfVis(get_turf(src_object)))
			return UI_CLOSE
		return UI_INTERACTIVE
	else if(get_dist(src_object, src) <= client.view)	// View does not return what one would expect while installed in an inteliCard
		return UI_INTERACTIVE

	return UI_CLOSE

/mob/living/silicon/pai/default_can_use_topic(src_object)
	// pAIs can only use themselves and the owner's radio.
	if((src_object == src || src_object == radio) && !stat)
		return UI_INTERACTIVE
	else
		return min(..(), UI_UPDATE)

/**
 * Like the mob side 'can_use_topic', checks, by default,
 * whether or not a user can see / interact with this.
 *
 * * This is min()'d with the result of the mob's default check,
 *   meaning this can only be used to *deny*, not *allow*. This is because
 *   if you want to make a datum always accept interaction, it's complicated enough
 *   that you shuold be making your own ui_state.
 */
/datum/proc/default_ui_status(mob/user)
	return UI_INTERACTIVE

/atom/default_ui_status(mob/user)
	. = ..()
	if(!can_interact(user) && !isAdminGhostAI(user))
		. = min(., UI_UPDATE)

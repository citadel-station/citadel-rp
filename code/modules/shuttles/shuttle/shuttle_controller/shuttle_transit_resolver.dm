//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * A target resolver for where to go during / after transit.
 * * Can also be used for 'flybys', by just having it return to origin dock.
 * * This is internally responsible for automatically
 *   unbinding if any held variables fall out of validity!
 *
 *   Resolvers may be kept around as long as a transit is in progress - which
 *   is defined to be 'until server restart' by the API.
 */
/datum/shuttle_transit_resolver

/**
 * Resolves target.
 *
 * * Returns a dock to dock with, and either an aligner to align
 *   to the dock, or a direction for centered landing.
 *
 * @return list(obj/shuttle_dock/dock, obj/shuttle_aligner/align_or_dir)
 */
/datum/shuttle_transit_resolver/proc/resolve()
	SHOULD_NOT_SLEEP(TRUE)
	return list(null, null)

/**
 * Simple resolver; binds to a certain dock with an alignment or direction.
 * * Used in majority of shuttle operations.
 */
/datum/shuttle_transit_resolver/simple
	var/obj/shuttle_dock/dock
	var/obj/shuttle_aligner/align
	var/centered_dir

/datum/shuttle_transit_resolver/simple/New(obj/shuttle_dock/dock, obj/shuttle_aligner/align_or_dir)
	if(dock)
		src.dock = dock
		RegisterSignal(dock, COMSIG_PARENT_QDELETING, CALLBACK(src, dock_deleted))
	else
		CRASH("Invalid dock type")

	if(align_or_dir)
		if(isnum(align_or_dir))
			src.centered_dir = align_or_dir
		else if(istype(align_or_dir))
			src.align = align_or_dir
			RegisterSignal(src.align, COMSIG_PARENT_QDELETING, CALLBACK(src, align_deleted))
		else
			CRASH("Invalid align_or_dir type")

/datum/shuttle_transit_resolver/simple/proc/dock_deleted()
	src.dock = null

/datum/shuttle_transit_resolver/simple/proc/align_deleted()
	src.align = null

/datum/shuttle_transit_resolver/simple/Destroy()
	if(src.dock)
		UnregisterSignal(src.dock, COMSIG_PARENT_QDELETING, CALLBACK(src, dock_deleted))
	if(src.align)
		UnregisterSignal(src.align, COMSIG_PARENT_QDELETING, CALLBACK(src, align_deleted))
	return ..()

/datum/shuttle_transit_resolver/simple/proc/resolve()
	SHOULD_NOT_SLEEP(TRUE)
	return list(src.dock, src.align ? src.align : src.centered_dir)

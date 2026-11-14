//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * Dispatches a fully constructed shuttle event.
 */
/datum/shuttle/proc/dispatch_event(datum/event_args/shuttle/event)
	SHOULD_NOT_SLEEP(TRUE)

	// check if they called New() on it properly
	ASSERT(event.shuttle == src)

	event.standard_dispatch()

/**
 * Fires an event off to all hooks
 * * Does not fire events off to our dock or ports!
 */
/datum/shuttle/proc/dispatch_event_to_hooks(datum/event_args/shuttle/event)
	SHOULD_NOT_SLEEP(TRUE)
	for(var/datum/shuttle_hook/hook as anything in hooks)
		hook.on_shuttle_event(event, src)

/datum/shuttle/proc/dispatch_event_to_port_hooks(datum/event_args/shuttle/event, obj/shuttle_aligner/port/port)
	port.dispatch_event_to_port_hooks(event)

/datum/shuttle/proc/dispatch_event_to_dock_hooks(datum/event_args/shuttle/event, obj/shuttle_dock/dock)
	dock.dispatch_event_to_dock_hooks(event)

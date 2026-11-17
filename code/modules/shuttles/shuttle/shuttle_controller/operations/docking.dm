//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/datum/shuttle_operation/docking
	var/set_state_on_success = SHUTTLE_DOCKING_STATE_UNKNOWN
	var/set_state_on_failure = SHUTTLE_DOCKING_STATE_UNKNOWN
	var/set_state_in_progress = SHUTTLE_DOCKING_STATE_UNKNOWN

	var/start_event_type
	var/success_event_type

/datum/shuttle_operation/docking/setup()
	controller.set_docking_state(set_state_in_progress)
	controller.dispatch_event(new start_event_type(
		controller,
		src,
		controller.shuttle.dock,
		controller.shuttle.docked_via_port,
	))

/datum/shuttle_operation/docking/on_finish(status)
	if(status == SHUTTLE_OPERATION_STATUS_SUCCESS)
		controller.set_docking_state(set_state_on_success)
	else
		controller.set_docking_state(set_state_on_failure)

/datum/shuttle_operation/docking/dock
	start_event_type = /datum/event_args/shuttle/dock/docking
	success_event_type = /datum/event_args/shuttle/dock/docked

	set_state_on_success = SHUTTLE_DOCKING_STATE_DOCKED
	set_state_in_progress = SHUTTLE_DOCKING_STATE_DOCKING

/datum/shuttle_operation/docking/dock/ui_serialize()
	. = ..()
	.["name"] = "Docking"

/datum/shuttle_operation/docking/undock
	start_event_type = /datum/event_args/shuttle/dock/undocking
	success_event_type = /datum/event_args/shuttle/dock/undocked

	set_state_on_success = SHUTTLE_DOCKING_STATE_UNDOCKED
	set_state_in_progress = SHUTTLE_DOCKING_STATE_UNDOCKING

/datum/shuttle_operation/docking/undock/ui_serialize()
	. = ..()
	.["name"] = "Undocking"

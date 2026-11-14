//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/datum/shuttle_operation/docking
	var/set_state_on_success = SHUTTLE_DOCKING_STATE_UNKNOWN
	var/set_state_on_failure = SHUTTLE_DOCKING_STATE_UNKNOWN
	var/set_state_in_progress = SHUTTLE_DOCKING_STATE_UNKNOWN

#warn impl

	/// ongoing docking event
	var/datum/event_args/shuttle/dock/docking_event





/datum/shuttle_operation/docking/dock
	set_state_on_success = SHUTTLE_DOCKING_STATE_DOCKED
	set_state_in_progress = SHUTTLE_DOCKING_STATE_DOCKING

/datum/shuttle_operation/docking/undock
	set_state_on_success = SHUTTLE_DOCKING_STATE_UNDOCKED
	set_state_in_progress = SHUTTLE_DOCKING_STATE_UNDOCKING


//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

//* Docking - Validity *//

/**
 * Check if a dock is a valid target.
 * * Used to check destinations before initiating a landing for a player command.
 * * This is because things like overmaps controllers can set manual dock
 *   and then fly out of range.
 */
/datum/shuttle_controller/proc/is_dock_valid_target(obj/shuttle_dock/dock)
	return TRUE

//* Docking - Control *//

/datum/shuttle_controller/proc/has_codes_for(obj/shuttle_dock/dock)
	if(dock.docking_code in docking_codes)
		return TRUE
	if(dock.dock_id in docking_always_has_code_to_ids)
		return TRUE
	return FALSE

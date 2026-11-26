//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/access_defaults
	var/list/req_access
	var/list/req_one_access

/datum/access_defaults/clone()
	var/datum/access_defaults/created = new()
	created.req_access = req_access?.Copy()
	created.req_one_access = req_one_access?.Copy()
	return created

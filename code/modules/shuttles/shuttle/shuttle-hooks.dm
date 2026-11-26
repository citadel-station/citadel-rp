//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/datum/shuttle/proc/register_hook(datum/shuttle_hook/hook)
	if(hook in hooks)
		. = FALSE
		CRASH("attempted to re-register a registered hook")

	hook.registered_shuttles += src
	hooks += hook
	. = TRUE

/datum/shuttle/proc/unregister_hook(datum/shuttle_hook/hook)
	if(!(hook in hooks))
		. = FALSE
		CRASH("attempted to unregister a hook that wasn't registered")

	// we don't clear blockers because you can actually ephemerally block
	// multiple shuttles with a hook and keep the current blockers around
	//
	// it's YOUR job to figure out how to unblock on unregister.
	hook.registered_shuttles -= src
	hooks -= hook
	. = TRUE

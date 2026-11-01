//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/inventory/proc/set_hand_count(count)
	LAZYINITLIST(held_items)

	if(length(held_items) > count)
		var/any_deleted = FALSE

		for(var/i in count + 1 to length(held_items))
			if(held_items[i])
				qdel(held_items[i])
				any_deleted = TRUE

		if(any_deleted)
			STACK_TRACE("Setting count [count] < [length(held_items)] with items in extra slots; they have been deleted")

	held_items.len = count

	for(var/datum/actor_hud/inventory/hud in huds_using)
		hud.rebuild()
	//! legacy
	owner.swap_hand(count ? clamp(owner.active_hand, 1, count) : null)
	//! end
	SEND_SIGNAL(src, COMSIG_INVENTORY_SLOT_REBUILD)

/datum/inventory/proc/get_hand_count()
	return length(held_items)

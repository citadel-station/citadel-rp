/obj/structure/halloween

	name = "Object"
	desc = "Fix me."
	icon = 'icons/obj/halloween.dmi'
	icon_state = "blank"
	layer = ABOVE_MOB_LAYER

/obj/structure/halloween/cauldron
	name = "cauldron"
	icon_state = "candycauldron"
	desc = "A large metal cauldron. It seems to be filled with... Lots of candy!"
	anchored = TRUE
	density = TRUE
	/**
	* Times taken by mindrefs; associative list mind ref --> amount
	*/
	var/list/datum/mind_ref/taken_by_mind_ref = list()
	// allow rolls by users
	var/allowed_rolls = 3

/obj/structure/halloween/cauldron/on_attack_hand(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return
	if(!clickchain.initiator?.mind)
		return
	var/datum/mind_ref/their_ref = clickchain.initiator.mind.get_mind_ref()
	var/already_taken = taken_by_mind_ref?[their_ref]
	if(already_taken >= allowed_rolls)
		clickchain.chat_feedback(
		SPAN_WARNING("You've already taken your share from the [src]!"),
		target = src,
		)
		return . | CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE

	clickchain.chat_feedback(
		SPAN_NOTICE("You rummage through the [src] and take some candy!"),
		target = src,
	)

  	// always record taking something BEFORE giving them in, incase something in the 'giving' bit runtimes and then they get infinite.
	LAZYINITLIST(taken_by_mind_ref) // only make list when needed / just in case
	taken_by_mind_ref[their_ref] += 1

	var/spawn_path = get_candy()
	var/obj/item/spawned = new spawn_path(src) // spawn in src in case we're over lava
	clickchain.performer.put_in_hands_or_drop(spawned)

	return . | CLICKCHAIN_DID_SOMETHING

/obj/structure/halloween/cauldron/proc/get_candy()
	var/list/candy = list(
		/obj/item/reagent_containers/food/snacks/centauri/chocolate,
		/obj/item/reagent_containers/food/snacks/centauri/chocolate,
		/obj/item/reagent_containers/food/snacks/centauri/chocolate,
		/obj/item/reagent_containers/food/snacks/centauri/chocolate,
		/obj/item/reagent_containers/food/snacks/centauri/chocolate,
		/obj/item/reagent_containers/food/snacks/centauri/wchocolate,
		/obj/item/reagent_containers/food/snacks/centauri/wchocolate,
		/obj/item/reagent_containers/food/snacks/centauri/wchocolate,
		/obj/item/reagent_containers/food/snacks/centauri/wchocolate,
		/obj/item/storage/single_use/bag/cookie,
		/obj/item/storage/single_use/bag/cookie,
		/obj/item/storage/single_use/bag/cookie,
		/obj/item/storage/single_use/bag/cookie,
		/obj/item/storage/single_use/bag/cookie,
		/obj/item/storage/single_use/bag/chococookie,
		/obj/item/storage/single_use/bag/chococookie,
		/obj/item/storage/single_use/bag/chococookie,
		/obj/item/storage/single_use/bag/chococookie,
		/obj/item/storage/single_use/bag/candycorn,
		/obj/item/storage/single_use/bag/candycorn,
		/obj/item/storage/single_use/bag/candycorn,
		/obj/item/storage/single_use/bag/candycorn,
		/obj/item/storage/single_use/bag/candycorn,
		/obj/item/storage/single_use/bag/raymonds,
		/obj/item/storage/single_use/bag/raymonds,
		/obj/item/storage/single_use/bag/raymonds,
		/obj/item/storage/single_use/bag/raymonds,
		/obj/item/storage/single_use/bag/raymonds,
		/obj/item/reagent_containers/food/snacks/honeychocolate,
		/obj/item/reagent_containers/food/snacks/honeychocolate,
		/obj/item/reagent_containers/food/snacks/honeychocolate,
		/obj/item/storage/single_use/bag/halloweengummy,
		/obj/item/storage/single_use/bag/halloweengummy,
		/obj/item/storage/single_use/bag/halloweengummy,
		/obj/item/storage/single_use/bag/greenchew,
		/obj/item/storage/single_use/bag/greenchew,
		/obj/item/storage/single_use/bag/greenchew,
		/obj/item/storage/single_use/bag/matchamilkcandy,
		/obj/item/storage/single_use/bag/matchamilkcandy,
		/obj/item/storage/single_use/bag/matchamilkcandy,
		/obj/item/storage/single_use/bag/californium,
		/obj/item/storage/single_use/bag/californium,
		/obj/item/storage/single_use/bag/californium,
		/obj/item/storage/single_use/bag/toroid,
		/obj/item/storage/single_use/bag/toroid,
		/obj/item/storage/single_use/bag/toroid/musk,
		/obj/item/storage/single_use/bag/toroid/musk,
		/obj/item/storage/single_use/bag/toroid/fruit,
		/obj/item/storage/single_use/bag/toroid/fruit,
		/obj/item/storage/single_use/bag/belochka
	)
	var/candy_type = pick(candy)
	return candy_type

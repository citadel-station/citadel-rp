/obj/item/implant/integrated_circuit
	name = "electronic implant"
	desc = "It's a case, for building very tiny electronics with."
	icon = 'icons/obj/integrated_electronics/electronic_setups.dmi'
	icon_state = "setup_implant"
	var/obj/item/electronic_assembly/implant/IC = null

/obj/item/implant/integrated_circuit/islegal()
	return TRUE

/obj/item/implant/integrated_circuit/Initialize(mapload)
	. = ..()
	IC = new(src)
	IC.implant = src

/obj/item/implant/integrated_circuit/Destroy()
	QDEL_NULL(IC)
	return ..()

/obj/item/implant/integrated_circuit/get_data()
	var/dat = {"
	<b>Implant Specifications:</b><BR>
	<b>Name:</b> Modular Implant<BR>
	<b>Life:</b> 3 years.<BR>
	<b>Important Notes: EMP can cause malfunctions in the internal electronics of this implant.</B><BR>
	<HR>
	<b>Implant Details:</b><BR>
	<b>Function:</b> Contains no innate functions until other components are added.<BR>
	<b>Special Features:</b>
	<i>Modular Circuitry</i>- Can be loaded with specific modular circuitry in order to fulfill a wide possibility of functions.<BR>
	<b>Integrity:</b> Implant is not shielded from electromagnetic interference, otherwise it is independent of subject's status."}
	return dat

/obj/item/implant/integrated_circuit/emp_act(severity)
	IC.emp_act(severity)

/obj/item/implant/integrated_circuit/examine(mob/user, dist)
	return IC.examine(user)

/obj/item/implant/integrated_circuit/attackby(var/obj/item/O, var/mob/user, list/params, clickchain_flags, damage_multiplier, datum/event_args/actor/clickchain/clickchain)
	if(IC)
		if (O.is_crowbar())
			var/turf/T = get_turf(src)
			IC.forceMove(T)
			src.icon_state = "circuitry-open"
			src.IC = null
			IC.implant = null
			playsound(T, 'sound/items/Crowbar.ogg', 50, TRUE)
			to_chat(usr, SPAN_NOTICE("You pull the circuitry out of \the [src]."))
			return clickchain_flags | CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE
	if(istype(O, /obj/item/electronic_assembly/implant))
		if(!IC)
			if(!user.attempt_insert_item_for_installation(O, src))
				return
			IC = O
			IC.implant = src
			src.icon_state = "circuitry"
			playsound(get_turf(src), 'sound/items/Deconstruct.ogg', 50, 1)
			to_chat(user, SPAN_NOTICE("You install the circuitry into \the [src]."))
			ui_interact(user)
			return
		return
	if(IC)
		return IC.attackby(O, user) ? null : ..()
	else
		..()

/obj/item/implant/integrated_circuit/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	IC.attack_self(user)

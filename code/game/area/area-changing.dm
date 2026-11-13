/**
 * Implementation of area changing.
 */
/proc/__area_change(list/turf/turfs, area/to_new_area)

	var/list/turf/changing = new /list(length(turfs))
	var/list/area/old_areas = new /list(length(turfs))
	var/list/requires_lighting_updates = new /list(length(turfs))

	for(var/turf/turf as anything in turfs)
		if(turf.loc == to_new_area)
			continue
		changing[i] = turf
		requires_lighting_updates[i] = turf.loc.dynamic_lighting != to_new_area.dynamic_lighting
		old_areas[i] = turf.loc

	to_new_area.contents.Add(changing)

	// go in one go for speed
	for(var/i in 1 to length(changing))
		var/turf/T = changing[i]

		if(requires_lighting_updates[i])
			if(to_new_area.dynamic_lighting)
				T.lighting_build_overlay()
			else
				T.lighting_clear_overlay()

		for(var/atom/movable/AM as anything in T)
			old_areas[i].Exited(AM, to_new_area)
		for(var/atom/movable/AM as anything in T)
			to_new_area.Entered(AM, old_areas[i])

		// *sigh*. this should be automatic, man.
		for(var/obj/machinery/M in T)
			M.power_change()

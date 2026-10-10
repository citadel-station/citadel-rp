/datum/map/sector/tundra_planet
	id = "tundra_planet"
	name = "Sector - Tundra Planet"
	width = 192
	height = 192
	levels = list(
		/datum/map_level/sector/tundra_planet,
		/datum/map_level/sector/tundra_planet/west,
	)

	legacy_assert_shuttle_datums = list(
		/datum/shuttle/autodock/overmap/maquis/raider,
		/datum/shuttle/autodock/overmap/maquis/interceptor,
	)

/datum/map_level/sector/tundra_planet
	id = "tundra_planet"
	name = "Sector Crucis Expanse - Tundra Planet East"
	display_name = "tundra_planet"
	path = "maps/sectors/vce_tundra_planet/levels/tundra_planet.dmm"
	base_turf = /turf/simulated/floor/fey/snow_grass
	struct_x = 1
	struct_y = 0
	struct_z = 0

	planet_path = /datum/planet/tundra_planet
	air_outdoors = /datum/atmosphere/planet/tundra_planet


/datum/map_level/sector/tundra_planet/west
	id = "MiaphusCaves192"
	name = "Sector Crucis Expanse - Tundra Planet West"
	display_name = "Miaphus - Caves"
	path = "maps/sectors/vce_tundra_planet/levels/tundra_planet_2.dmm"
	base_turf = /turf/simulated/floor/fey/snow_grass
	struct_x = 0
	struct_y = 0
	struct_z = 0

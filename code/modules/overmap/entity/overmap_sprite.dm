//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * Metadata for overmap entity sprites.
 * * Sprites are assumed centered.
 */
/datum/prototype/overmap_sprite
	abstract_type = /datum/prototype/overmap_sprite

	var/icon
	var/icon_state
	/// defaults to state
	var/name
	var/width
	var/height
	var/has_moving_state = FALSE

/datum/prototype/overmap_sprite/big_ship
	id = "big_ship"

	icon = 'icons/modules/overmap/entity.dmi'
	icon_state = "ship"
	has_moving_state = TRUE
	width = 32
	height = 32

/datum/prototype/overmap_sprite/sector
	id = "sector"

	icon = 'icons/modules/overmap/entity.dmi'
	icon_state = "sector"
	width = 32
	height = 32

/datum/prototype/overmap_sprite/object
	id = "object"

	icon = 'icons/modules/overmap/entity.dmi'
	icon_state = "object"
	width = 16
	height = 16

/datum/prototype/overmap_sprite/globe
	id = "globe"

	icon = 'icons/modules/overmap/entity.dmi'
	icon_state = "globe"
	width = 32
	height = 32

/datum/prototype/overmap_sprite/cracked_globe
	id = "cracked_globe"

	icon = 'icons/modules/overmap/entity.dmi'
	icon_state = "cracked_globe"
	width = 32
	height = 32

/datum/prototype/overmap_sprite/shuttle
	id = "shuttle"

	icon = 'icons/modules/overmap/entity.dmi'
	icon_state = "shuttle"
	width = 32
	height = 32
	has_moving_state = TRUE

/datum/prototype/overmap_sprite/portal
	id = "portal"
	id = "portal"
	icon = 'icons/modules/overmap/entity.dmi'
	icon_state = "portal"
	width = 32
	height = 32

/datum/prototype/overmap_sprite/fuel_depot
	id = "fuel_depot"

	icon = 'icons/modules/overmap/entity.dmi'
	icon_state = "fuel_depot"
	width = 32
	height = 32

/datum/prototype/overmap_sprite/pirate_base
	id = "pirate_base"

	icon = 'icons/modules/overmap/entity.dmi'
	icon_state = "piratebase"
	width = 32
	height = 32

/datum/prototype/overmap_sprite/comet
	id = "comet"

	icon = 'icons/modules/overmap/entity.dmi'
	icon_state = "comet"
	width = 32
	height = 32

/datum/prototype/overmap_sprite/asteroid
	id = "asteroid"

	icon = 'icons/modules/overmap/entity.dmi'
	icon_state = "asteroid"
	width = 32
	height = 32

/datum/prototype/overmap_sprite/probe
	id = "probe"

	icon = 'icons/modules/overmap/entity.dmi'
	icon_state = "probe"
	width = 32
	height = 32

/datum/prototype/overmap_sprite/unknown
	id = "unknown"

	icon = 'icons/modules/overmap/entity.dmi'
	icon_state = "unknown"
	width = 32
	height = 32

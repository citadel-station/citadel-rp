/datum/asset_pack/spritesheet/overmaps
	name = "overmaps"

/datum/asset_pack/spritesheet/overmaps/generate()
	for(var/datum/prototype/overmap_sprite/sprite as anything in RSovermap_sprites.fetch_subtypes_immutable(/datum/prototype/overmap_sprite))
		insert(
			sprite.id,
			sprite.icon,
			sprite.icon_state,
		)

//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Just a shuttle preview render.
 */
/atom/movable/render/shuttle_preview
	name = "shuttle preview"
	desc = "A preview of a shuttle; probably for landing, or something."
	vis_flags = VIS_INHERIT_LAYER | VIS_INHERIT_PLANE | VIS_INHERIT_DIR
	plane = ABOVE_LIGHTING_PLANE
	layer = ABOVE_LIGHTING_LAYER_MAIN
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

	var/generated_dir = NORTH

/atom/movable/render/shuttle_preview/setDir(newdir)
	. = ..()

	// clockwise of north
	var/angle = dir2angle(dir) - dir2angle(generated_dir)
	angle = SIMPLIFY_DEGREES(angle)

	// so funny thing; we center the overlays on the anchor for a reason.
	// by doing that, we can rotate the shuttle preview
	// around itself via transform matrix.
	var/matrix/rotated = matrix()
	rotated.Turn(angle)
	transform = rotated

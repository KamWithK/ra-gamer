package drawing

import rl "vendor:raylib"

import "../types"

SpriteSheet :: struct {
	texture:         ^rl.Texture2D,
	cell_size:       types.Vec2(uint),
	cell_dimensions: types.Vec2(uint),
}

create_sheet :: proc(
	texture: ^rl.Texture2D,
	cell_size: uint,
	cell_dimensions: types.Vec2(uint),
) -> SpriteSheet {
	sheet := SpriteSheet {
		texture         = texture,
		cell_size       = {cell_size, cell_size},
		cell_dimensions = cell_dimensions,
	}

	return sheet
}

draw_tile :: proc(
	sprite_sheet: ^SpriteSheet,
	tile_coords: types.Vec2(uint),
	offset: types.Vec2(f32),
	scale: f32,
) {
	rect := rl.Rectangle {
		f32(tile_coords.x * sprite_sheet.cell_size.x),
		f32(tile_coords.y * sprite_sheet.cell_size.y),
		f32(sprite_sheet.cell_size.x),
		f32(sprite_sheet.cell_size.y),
	}

	draw_sprite(sprite_sheet, rect, offset, scale)
}

draw_sprite :: proc(
	sprite_sheet: ^SpriteSheet,
	source_rect: rl.Rectangle,
	offset: types.Vec2(f32),
	scale: f32,
) {
	rl.DrawTexturePro(
		sprite_sheet.texture^,
		source_rect,
		{offset.x, offset.y, f32(source_rect.width * scale), f32(source_rect.height * scale)},
		{0, 0},
		0,
		rl.WHITE,
	)
}

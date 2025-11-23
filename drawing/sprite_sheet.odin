package drawing

import "core:math/linalg"
import rl "vendor:raylib"

SpriteSheet :: struct {
	texture:         ^rl.Texture2D,
	cell_size:       [2]uint,
	cell_dimensions: [2]uint,
}

create_sheet :: proc(
	texture: ^rl.Texture2D,
	cell_size: uint,
	cell_dimensions: [2]uint,
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
	tile_coords: uint,
	offset: linalg.Vector2f32,
	scale: f32,
	flipped: bool,
) {
	tile_x := tile_coords % sprite_sheet.cell_dimensions.x
	tile_y := tile_coords / sprite_sheet.cell_dimensions.x
	rect := rl.Rectangle {
		f32(tile_x * sprite_sheet.cell_size.x),
		f32(tile_y * sprite_sheet.cell_size.y),
		f32(sprite_sheet.cell_size.x),
		f32(sprite_sheet.cell_size.y),
	}
	if flipped {
		rect.width *= -1
		rect.x += f32(sprite_sheet.cell_size.x)
	}

	draw_sprite(sprite_sheet, rect, offset, scale)
}

draw_sprite :: proc(
	sprite_sheet: ^SpriteSheet,
	source_rect: rl.Rectangle,
	offset: linalg.Vector2f32,
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

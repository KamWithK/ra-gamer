package drawing

import rl "vendor:raylib"

Tile :: struct {
	sheet_idx: uint,
	pos:       [2]uint,
}

Tilemap :: struct {
	sheet:          ^SpriteSheet,
	tiles:          [dynamic]Tile,
	floor_collider: rl.Rectangle,
}

test_map :: proc(sheet: ^SpriteSheet) -> Tilemap {
	tiles := make([dynamic]Tile)

	floor_offset: uint = 400

	floor_rect := rl.Rectangle{0, f32(floor_offset), 1920, 16}

	append(&tiles, Tile{0, {0, floor_offset}})

	for i in 1 ..< 119 {
		append(&tiles, Tile{1, {uint(16 * i), floor_offset}})
	}
	append(&tiles, Tile{2, {1904, floor_offset}})


	tilemap := Tilemap {
		sheet          = sheet,
		tiles          = tiles,
		floor_collider = floor_rect,
	}

	return tilemap
}

draw_tilemap :: proc(tilemap: ^Tilemap) {

	for tile in tilemap.tiles {
		draw_tile(tilemap.sheet, tile.sheet_idx, {f32(tile.pos.x), f32(tile.pos.y)}, 1, false)
	}
}

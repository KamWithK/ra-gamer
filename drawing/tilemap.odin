package drawing

Tile :: struct {
	sheet_idx: uint,
	pos:       [2]uint,
}

Tilemap :: struct {
	sheet: ^SpriteSheet,
	tiles: [dynamic]Tile,
}

test_map :: proc(sheet: ^SpriteSheet) -> Tilemap {
	tiles := make([dynamic]Tile)


	append(
		&tiles,
		Tile{0, {0, 64}},
		Tile{1, {16, 64}},
		Tile{1, {32, 64}},
		Tile{1, {48, 64}},
		Tile{1, {64, 64}},
		Tile{2, {80, 64}},
	)

	tilemap := Tilemap {
		sheet = sheet,
		tiles = tiles,
	}

	return tilemap
}

draw_tilemap :: proc(tilemap: ^Tilemap) {

	for tile in tilemap.tiles {
		draw_tile(tilemap.sheet, tile.sheet_idx, {f32(tile.pos.x), f32(tile.pos.y)}, 1, false)
	}
}

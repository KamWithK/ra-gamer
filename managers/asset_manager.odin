package managers

import rl "vendor:raylib"

import "../drawing"


AssetManager :: struct {
	textures: map[string]rl.Texture2D,
}

load_texture :: proc(assets: ^AssetManager, path: cstring, name: string) -> ^rl.Texture2D {
	tex := rl.LoadTexture(path)

	assets.textures[name] = tex

	return &assets.textures[name]
}

get_texture :: proc(assets: ^AssetManager, name: string) -> ^rl.Texture2D {
	return &assets.textures[name]
}

SpriteSheetManager :: struct {
	sheets: map[string]drawing.SpriteSheet,
}

create_sheet :: proc(
	sheets: ^SpriteSheetManager,
	name: string,
	texture: ^rl.Texture2D,
	cell_size: uint,
	cell_dimensions: [2]uint,
) -> ^drawing.SpriteSheet {
	sheets.sheets[name] = drawing.SpriteSheet {
		texture         = texture,
		cell_size       = {cell_size, cell_size},
		cell_dimensions = cell_dimensions,
	}

	return &sheets.sheets[name]
}

insert_sheet :: proc(
	sheet_manager: ^SpriteSheetManager,
	sheet: drawing.SpriteSheet,
	name: string,
) {
	sheet_manager.sheets[name] = sheet
}

get_sheet :: proc(sheet_manager: ^SpriteSheetManager, name: string) -> ^drawing.SpriteSheet {
	return &sheet_manager.sheets[name]
}

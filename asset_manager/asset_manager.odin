package asset_manager

import rl "vendor:raylib"


AssetManager :: struct {
	textures: map[string]rl.Texture2D,
}

load_texture :: proc(assets: ^AssetManager, path: cstring, name: string) {
	tex := rl.LoadTexture(path)

	assets.textures[name] = tex
}

get_texture :: proc(assets: ^AssetManager, name: string) -> ^rl.Texture2D {
	return &assets.textures[name]
}

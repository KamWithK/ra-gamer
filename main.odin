package game

import rl "vendor:raylib"

import "asset_manager"
import "drawing"

WINDOW_WIDTH :: 1920
WINDOW_HEIGHT :: 1080
FPS :: 60

main :: proc() {
	rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "game")
	defer rl.CloseWindow()
	rl.SetWindowFocused()
	rl.SetTargetFPS(FPS)

	assets := asset_manager.AssetManager{}

	asset_manager.load_texture(&assets, "assets/Main Characters/Mask Dude/Run (32x32).png", "mask")
	knight := asset_manager.get_texture(&assets, "mask")
	test_sheet := drawing.create_sheet(knight, 32, {1, 12})

	for !rl.WindowShouldClose() {
		update()
		draw(&assets, &test_sheet)
	}
}

update :: proc() {

}

draw :: proc(assets: ^asset_manager.AssetManager, sheet: ^drawing.SpriteSheet) {
	rl.ClearBackground(rl.WHITE)
	rl.BeginDrawing()

	drawing.draw_sprite(sheet, {0, 0, 32, 32}, {50, 50}, 2)

	rl.DrawFPS(0, 0)

	rl.EndDrawing()
}

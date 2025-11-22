package game

import "core:math/linalg"
import rl "vendor:raylib"

import "asset_manager"
import "drawing"

WINDOW_WIDTH :: 1920
WINDOW_HEIGHT :: 1080
WINDOW_FLAGS :: rl.ConfigFlags{.WINDOW_RESIZABLE}
FPS :: 60
SPEED_FACTOR :: 10

Input :: struct {
	down, up, left, right, space: bool,
	mouse_pos:                    linalg.Vector2f32,
	mouse_left, mouse_right:      bool,
}

Player :: struct {
	pos: linalg.Vector3f32,
}

Global :: struct {
	input:  Input,
	player: Player,
}
g: Global

main :: proc() {
	rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "game")
	rl.SetWindowState(WINDOW_FLAGS)
	defer rl.CloseWindow()
	rl.SetWindowFocused()
	rl.SetTargetFPS(FPS)

	assets := asset_manager.AssetManager{}

	asset_manager.load_texture(&assets, "assets/Main Characters/Mask Dude/Run (32x32).png", "mask")
	knight := asset_manager.get_texture(&assets, "mask")
	test_sheet := drawing.create_sheet(knight, 32, {1, 12})

	g.player.pos.xy = 50

	for !rl.WindowShouldClose() {
		event()
		update()
		draw(&assets, &test_sheet)
	}
}

event :: proc() {
	g.input = {
		down        = rl.IsKeyDown(.DOWN) || rl.IsKeyDown(.S),
		up          = rl.IsKeyDown(.UP) || rl.IsKeyDown(.W),
		left        = rl.IsKeyDown(.LEFT) || rl.IsKeyDown(.A),
		right       = rl.IsKeyDown(.RIGHT) || rl.IsKeyDown(.D),
		space       = rl.IsKeyDown(.SPACE),
		mouse_pos   = rl.GetMousePosition(),
		mouse_left  = rl.IsMouseButtonPressed(.LEFT),
		mouse_right = rl.IsMouseButtonPressed(.RIGHT),
	}
}

update :: proc() {
	move_input: linalg.Vector3f32
	if g.input.down do move_input.y += 1
	if g.input.up do move_input.y -= 1
	if g.input.left do move_input.x -= 1
	if g.input.right do move_input.x += 1

	if move_input.x != 0 && move_input.y != 0 do move_input.xy = move_input.xy * 1.41 * 0.5
	g.player.pos += move_input * SPEED_FACTOR
}

draw :: proc(assets: ^asset_manager.AssetManager, sheet: ^drawing.SpriteSheet) {
	rl.ClearBackground(rl.WHITE)
	rl.BeginDrawing()

	drawing.draw_sprite(sheet, {0, 0, 32, 32}, {g.player.pos.x, g.player.pos.y}, 2)

	rl.DrawFPS(0, 0)

	rl.EndDrawing()
}


package game

import "core:log"
import "core:math/linalg"
import rl "vendor:raylib"

import "drawing"
import "managers"

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
	pos:       linalg.Vector3f32,
	vel:       linalg.Vector3f32,
	run_anim:  drawing.Animation,
	face_left: bool,
}

Global :: struct {
	input:  Input,
	player: Player,
	assets: managers.AssetManager,
	sheets: managers.SpriteSheetManager,
}
g: Global

main :: proc() {
	using managers

	context.logger = log.create_console_logger()

	rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "game")
	rl.SetWindowState(WINDOW_FLAGS)
	defer rl.CloseWindow()
	rl.SetWindowFocused()
	rl.SetTargetFPS(FPS)

	g.assets = AssetManager{}
	g.sheets = SpriteSheetManager{}

	mask_run := load_texture(
		&g.assets,
		"assets/Main Characters/Mask Dude/Run (32x32).png",
		"mask_run",
	)
	test_sheet := drawing.create_sheet(mask_run, 32, {12, 1})
	insert_sheet(&g.sheets, test_sheet, "mask_run")

	g.player.run_anim = drawing.Animation {
		sprite_sheet  = get_sheet(&g.sheets, "mask_run"),
		frames        = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11},
		current_frame = 0,
		frame_period  = 0.05,
	}

	g.player.pos.xy = 50

	for !rl.WindowShouldClose() {
		event()
		update()
		draw()
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
	dt := rl.GetFrameTime()
	move_input: linalg.Vector3f32
	g.player.face_left = false
	if g.input.down do move_input.y += 1
	if g.input.up do move_input.y -= 1
	if g.input.left {
		move_input.x -= 1
		g.player.face_left = true
	}
	if g.input.right do move_input.x += 1

	if move_input.xy != 0 do move_input.xy *= 1.41 * 0.5
	g.player.pos += move_input * SPEED_FACTOR

	drawing.update_animation(&g.player.run_anim, dt)
}

draw :: proc() {
	rl.ClearBackground(rl.WHITE)
	rl.BeginDrawing()

	player_run := &g.player.run_anim
	drawing.draw_tile(
		player_run.sprite_sheet,
		player_run.frames[player_run.current_frame],
		g.player.pos.xy,
		1,
		g.player.face_left,
	)

	rl.DrawFPS(0, 0)

	rl.EndDrawing()
}

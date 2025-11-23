package game

import "core:fmt"
import "core:log"
import "core:math/linalg"
import rl "vendor:raylib"

import "drawing"
import "managers"

WINDOW_WIDTH :: 1920
WINDOW_HEIGHT :: 1080
WINDOW_FLAGS :: rl.ConfigFlags{.WINDOW_RESIZABLE}
FPS :: 60
SPEED_FACTOR :: 500
FRICTION :: 1.5

Input :: struct {
	down, up, left, right, space: bool,
	mouse_pos:                    linalg.Vector2f32,
	mouse_left, mouse_right:      bool,
}

Player :: struct {
	pos:       linalg.Vector3f32,
	vel:       linalg.Vector3f32,
	run_anim:  ^drawing.Animation,
	idle_anim: ^drawing.Animation,
	face_left: bool,
	collider:  rl.Rectangle,
	on_floor:  bool,
}

Global :: struct {
	input:   Input,
	player:  Player,
	assets:  managers.AssetManager,
	sheets:  managers.SpriteSheetManager,
	tilemap: drawing.Tilemap,
}
g: Global

init :: proc() {
	using managers

	context.logger = log.create_console_logger()

	rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "game")
	rl.SetWindowState(WINDOW_FLAGS)
	rl.SetWindowFocused()
	rl.SetTargetFPS(FPS)


	terrain := load_texture(&g.assets, "assets/Terrain/Terrain (16x16).png", "terrain")
	terrain_sheet := create_sheet(&g.sheets, "terrain", terrain, 16, {22, 11})

	g.tilemap = drawing.test_map(terrain_sheet)


	mask_run := load_texture(
		&g.assets,
		"assets/Main Characters/Mask Dude/Run (32x32).png",
		"mask_run",
	)
	create_sheet(&g.sheets, "mask_run", mask_run, 32, {12, 1})


	mask_idle := load_texture(
		&g.assets,
		"assets/Main Characters/Mask Dude/Idle (32x32).png",
		"mask_idle",
	)
	create_sheet(&g.sheets, "mask_idle", mask_idle, 32, {11, 1})

	idle_frames := new([dynamic]uint)
	append(idle_frames, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10)

	run_frames := new([dynamic]uint)
	append(run_frames, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10)

	g.player.idle_anim = new(drawing.Animation)
	g.player.idle_anim.sprite_sheet = get_sheet(&g.sheets, "mask_idle")
	g.player.idle_anim.frames = idle_frames[:]
	g.player.idle_anim.current_frame = 0
	g.player.idle_anim.frame_period = 0.05

	g.player.run_anim = new(drawing.Animation)
	g.player.run_anim.sprite_sheet = get_sheet(&g.sheets, "mask_run")
	g.player.run_anim.frames = run_frames[:]
	g.player.run_anim.current_frame = 0
	g.player.run_anim.frame_period = 0.05


	g.player.pos.xy = 50

	g.player.collider = {g.player.pos.x, g.player.pos.y, 32, 32}
}

main :: proc() {

	using managers

	init()
	defer rl.CloseWindow()


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
	if g.input.left {
		move_input.x -= 1
		g.player.face_left = true
	}
	if g.input.right {
		move_input.x += 1
		g.player.face_left = false
	}


	if move_input.xy != 0 do move_input.xy *= 1.41 * 0.5
	acceleration := move_input * SPEED_FACTOR
	acceleration -= FRICTION * g.player.vel

	if g.input.up && g.player.on_floor {
		g.player.on_floor = false
		acceleration.y = -30000
	}

	acceleration.y += 500

	// (1/2)at^2 + vt + p
	g.player.pos += 0.5 * acceleration * dt * dt + g.player.vel * dt
	g.player.vel += acceleration * dt

	drawing.update_animation(g.player.run_anim, dt)
	g.player.collider = {g.player.pos.x, g.player.pos.y, 32, 32}

	if rl.CheckCollisionRecs(g.player.collider, g.tilemap.floor_collider) {
		g.player.on_floor = true
		g.player.pos.y = g.tilemap.floor_collider.y - 32
		g.player.vel.y = 0
	}
}

draw :: proc() {
	rl.ClearBackground(rl.WHITE)
	rl.BeginDrawing()

	drawing.draw_tilemap(&g.tilemap)

	player_run := g.player.run_anim
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

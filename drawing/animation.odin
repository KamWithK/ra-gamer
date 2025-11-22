package drawing


Animation :: struct {
	sprite_sheet:  ^SpriteSheet,
	frames:        [][2]uint,
	current_frame: uint,
	frame_period:  f32,
	frame_timer:   f32,
}

update_animation :: proc(anim: ^Animation, dt: f32) {
	anim.frame_timer += dt

	if anim.frame_timer >= anim.frame_period {
		anim.frame_timer = 0
		anim.current_frame += 1
		anim.current_frame %= len(anim.frames)
	}
}

package mallard

import "core:fmt"
import "core:log"
import "core:mem"

import mc "./common"

DEFAULT_WINDOW_WIDTH: i32 = 1280
DEFAULT_WINDOW_HEIGHT: i32 = 720
DEFAULT_VIEWPORT_WIDTH: i32 = 960
DEFAULT_VIEWPORT_HEIGHT: i32 = 540
track: mem.Tracking_Allocator

cog_texture: mc.Texture
test_min_size: mc.Vec2 = {25, 25}
test_vertical_alignment: Mallard_Vertical_Alignment = .TOP

main :: proc() {
	mem.tracking_allocator_init(&track, context.allocator)
	context.allocator = mem.tracking_allocator(&track)
	context.logger = log.create_console_logger(log.Level.Info)

	init()

	for !mc._windowShouldClose() {
		delta := mc._getFrameTime()
		mal_begin_frame()

		// NOTE(devon): Still needs userland to let us know when the
		// screen has been resized
		if mc._isWindowResized() {
			mal_resized({mc._getScreenWidth(), mc._getScreenHeight()})
		}

		build_ui(delta)

		mal_end_frame()
	}

	deinit()
}

init :: proc() {
	mc._setConfigFlags(
		{mc.ConfigFlag.MSAA_4X_HINT} |
		{mc.ConfigFlag.WINDOW_MAXIMIZED} |
		{mc.ConfigFlag.WINDOW_RESIZABLE},
	)
	mc._initWindow(state.screen_width, state.screen_height, "Mallard")
	mc._setTargetFPS(60)

	mal_init()

	cog_texture = mc._loadTexture("./assets/icons/cog-32.png")
}

deinit :: proc(allocator := context.allocator) {
	mal_deinit()

	mc._unloadTexture(cog_texture)
	mc._closeWindow()

	log.destroy_console_logger(context.logger)
	for _, leak in track.allocation_map {
		fmt.eprintf("%v leaked %v bytes\n", leak.location, leak.size)
	}

	for bad_free in track.bad_free_array {
		fmt.eprintf("%p allocation %p was freed incorrectly\n", bad_free.location, bad_free.memory)
	}
}

build_ui :: proc(delta_time: f32) {
	vl := mal_vertical_layout(
		mc.Rect{100, 0, 200, f32(state.screen_height)},
		test_vertical_alignment,
	)
	mal_push_container(vl)

	if mal_layout_button(mc.Vec2{32, 32}, .BEGIN, .CENTER, "First Button") {
		log.info("First button has been hit")
	}

	if mal_layout_button(test_min_size, .BEGIN, .CENTER, "Second Button") {
		log.info("Second button has been hit")
	}

	if mal_layout_button(mc.Vec2{32, 32}, .BEGIN, .CENTER, "Third Button") {
		log.info("Third button has been hit")
	}

	// v2 := mal_vertical_layout(mc.Rect{50, 100, 200, f32(state.screen_height - 100)}, .TOP)
	// mal_push_container(v2)
	// if mal_button(mc.Vec2{50, 50}, "Far Button") {
	// 	log.info("DA BUTTON BEEN HIT")
	// }
	// mal_pop_container()

	mal_pop_container()
	inc: f32 = 10.0
	if mal_button(mc.Vec2{50, 200}, mc.Vec2{25, 25}, "-x") {
		test_min_size.x -= inc
	}
	if mal_button(mc.Vec2{50, 230}, mc.Vec2{25, 25}, "-y") {
		test_min_size.y -= inc
	}
	if mal_button(mc.Vec2{80, 200}, mc.Vec2{25, 25}, "+x") {
		test_min_size.x += inc
	}
	if mal_button(mc.Vec2{80, 230}, mc.Vec2{25, 25}, "+y") {
		test_min_size.y += inc
	}
	// Vertical Alignment
	if mal_button(mc.Vec2{10, 300}, mc.Vec2{25, 25}, "TOP") {
		test_vertical_alignment = .TOP
	}
	if mal_button(mc.Vec2{60, 300}, mc.Vec2{25, 25}, "CENTER") {
		test_vertical_alignment = .CENTER
	}
	if mal_button(mc.Vec2{135, 300}, mc.Vec2{25, 25}, "BOTTOM") {
		test_vertical_alignment = .BOTTOM
	}
}

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
test_horizontal_alignment: Mallard_Horizontal_Alignment = .CENTER
test_horizontal_height: f32 = 0.0
test_layout_position := mc.Vec2{0.0, 0.0}

main :: proc() {
	mem.tracking_allocator_init(&track, context.allocator)
	context.allocator = mem.tracking_allocator(&track)
	context.logger = log.create_console_logger(log.Level.Info)

	init()

	when ODIN_OS == .Windows {
		mc._setExitKey(mc.KeyboardKey.ESCAPE)
	} else {
		mc._setExitKey(mc.KeyboardKey.CAPS_LOCK)
	}

	for !mc._windowShouldClose() {
		delta := mc._getFrameTime()
		mal_begin_frame()

		// NOTE(devon): Still needs userland to let us know when the
		// screen has been resized
		if mc._isWindowResized() {
			mal_resized({mc._getScreenWidth(), mc._getScreenHeight()})
		}

		if mc._isKeyReleased(mc.KeyboardKey.Q) {
			test_horizontal_alignment = .LEFT
		}

		if mc._isKeyReleased(mc.KeyboardKey.W) {
			test_horizontal_alignment = .CENTER
		}

		if mc._isKeyReleased(mc.KeyboardKey.E) {
			test_horizontal_alignment = .RIGHT
		}

		if mc._isKeyReleased(mc.KeyboardKey.A) {
			test_vertical_alignment = .TOP
		}

		if mc._isKeyReleased(mc.KeyboardKey.S) {
			test_vertical_alignment = .CENTER
		}

		if mc._isKeyReleased(mc.KeyboardKey.D) {
			test_vertical_alignment = .BOTTOM
		}
		// Min size
		inc: f32 = 10.0
		if mc._isKeyReleased(mc.KeyboardKey.LEFT) {
			test_min_size.x -= inc
		}

		if mc._isKeyReleased(mc.KeyboardKey.RIGHT) {
			test_min_size.x += inc
		}
		if mc._isKeyReleased(mc.KeyboardKey.DOWN) {
			test_min_size.y -= inc
		}

		if mc._isKeyReleased(mc.KeyboardKey.UP) {
			test_min_size.y += inc
		}

		speed: f32 = 4.0
		if mc._isKeyDown(mc.KeyboardKey.H) {
			test_layout_position.x -= speed
		}

		if mc._isKeyDown(mc.KeyboardKey.L) {
			test_layout_position.x += speed
		}
		if mc._isKeyDown(mc.KeyboardKey.J) {
			test_layout_position.y += speed
		}
		if mc._isKeyDown(mc.KeyboardKey.K) {
			test_layout_position.y -= speed
		}

		build_ui(delta)
		//layout_ui(delta)

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
		fmt.eprintf(
			"%p allocation %p was freed incorrectly\n",
			bad_free.location,
			bad_free.memory,
		)
	}
}

build_ui :: proc(delta_time: f32) {
	//hl := mal_horizontal_layout(
	//	mc.Rect{0, test_horizontal_height, f32(state.screen_width), 100},
	//	test_horizontal_alignment,
	//)
	//mal_push_container(hl)

	//vl := mal_vertical_layout(
	//	mc.Rect{600, 0, 200, f32(state.screen_height)},
	//	test_vertical_alignment,
	//)
	//mal_push_container(vl)


	//if mal_layout_button(
	//	mal_id(),
	//	mc.Vec2{32, 32},
	//	.CENTER,
	//	.FILL,
	//	"First Button",
	//) {
	//	log.info("First button has been hit")
	//}

	//if mal_layout_button(
	//	mal_id(),
	//	test_min_size,
	//	.CENTER,
	//	.CENTER,
	//	"Second Button",
	//) {
	//	log.info("Second button has been hit")
	//}

	//if mal_layout_button(
	//	mal_id(),
	//	mc.Vec2{32, 32},
	//	.CENTER,
	//	.CENTER,
	//	"Third Button",
	//) {
	//	log.info("Third button has been hit")
	//}
	//mal_pop_container()
	//mal_pop_container()

	//svl := mal_vertical_layout(
	//	mc.Rect{500, 300, 200, f32(state.screen_height - 300)},
	//	test_vertical_alignment,
	//)
	//mal_push_container(svl)

	//if mal_layout_button(
	//	mal_id(),
	//	mc.Vec2{32, 32},
	//	.CENTER,
	//	.CENTER,
	//	"First Button",
	//) {
	//	log.info("First button has been hit")
	//}

	//if mal_layout_button(
	//	mal_id(),
	//	test_min_size,
	//	.CENTER,
	//	.CENTER,
	//	"Second Button",
	//) {
	//	log.info("Second button has been hit")
	//}


	//mal_pop_container()


	//min_size_lo := mal_horizontal_layout(mc.Rect{50, 400, 100, 45}, .LEFT)
	//mal_push_container(min_size_lo)

	//inc: f32 = 10.0
	//if mal_layout_button(mal_id(), mc.Vec2{32, 32}, .CENTER, .CENTER, "-x") {
	//	test_min_size.x -= inc
	//}
	//if mal_layout_button(mal_id(), mc.Vec2{32, 32}, .CENTER, .CENTER, "-y") {
	//	test_horizontal_height -= inc
	//}
	//if mal_layout_button(mal_id(), mc.Vec2{32, 32}, .CENTER, .CENTER, "+x") {
	//	test_min_size.x += inc
	//}
	//if mal_layout_button(mal_id(), mc.Vec2{32, 32}, .CENTER, .CENTER, "+y") {
	//	test_horizontal_height += inc
	//}

	//mal_pop_container()


	// Vertical Alignment
	alv := mal_vertical_layout(
		mc.Rect{test_layout_position.x, test_layout_position.y, 200, 300.0},
		test_vertical_alignment,
	)
	mal_push_container(alv)

	// Horizontal Alignment
	alh := mal_horizontal_layout(mc.Rect{}, .LEFT)
	alh.vertical_sizing = .BEGIN
	alh.horizontal_sizing = .BEGIN
	mal_push_container(alh)
	row := 1

	if mal_layout_button(mal_id(), mc.Vec2{25, 25}, .CENTER, .CENTER, "LEFT") {
		// test_vertical_alignment = .TOP
		test_horizontal_alignment = .LEFT
		log.infof("R: %v, C: %v\n", row, 1)
	}
	if mal_layout_button(mal_id(), test_min_size, .CENTER, .CENTER, "CENTER") {
		// test_vertical_alignment = .CENTER
		test_horizontal_alignment = .CENTER
		log.infof("R: %v, C: %v\n", row, 2)
	}
	if mal_layout_button(
		mal_id(),
		mc.Vec2{100, 25},
		.CENTER,
		.CENTER,
		"RIGHT",
	) {
		// test_vertical_alignment = .BOTTOM
		test_horizontal_alignment = .RIGHT
		log.infof("R: %v, C: %v\n", row, 3)
	}
	mal_pop_container()

	alh2 := mal_horizontal_layout(mc.Rect{}, .LEFT)
	alh2.vertical_sizing = .BEGIN
	alh2.horizontal_sizing = .BEGIN
	mal_push_container(alh2)
	row = 2

	if mal_layout_button(mal_id(), mc.Vec2{25, 25}, .CENTER, .CENTER, "LEFT") {
		// test_vertical_alignment = .TOP
		test_horizontal_alignment = .LEFT
		log.infof("R: %v, C: %v\n", row, 1)
	}
	if mal_layout_button(mal_id(), test_min_size, .CENTER, .CENTER, "CENTER") {
		// test_vertical_alignment = .CENTER
		test_horizontal_alignment = .CENTER
		log.infof("R: %v, C: %v\n", row, 2)
	}
	if mal_layout_button(
		mal_id(),
		mc.Vec2{100, 25},
		.CENTER,
		.CENTER,
		"RIGHT",
	) {
		// test_vertical_alignment = .BOTTOM
		test_horizontal_alignment = .RIGHT
		log.infof("R: %v, C: %v\n", row, 3)
	}
	mal_pop_container()

	alh3 := mal_horizontal_layout(mc.Rect{}, .LEFT)
	alh3.vertical_sizing = .BEGIN
	alh3.horizontal_sizing = .BEGIN
	mal_push_container(alh3)
	row = 3

	if mal_layout_button(mal_id(), mc.Vec2{25, 25}, .CENTER, .CENTER, "LEFT") {
		// test_vertical_alignment = .TOP
		test_horizontal_alignment = .LEFT
		log.infof("R: %v, C: %v\n", row, 1)
	}
	if mal_layout_button(mal_id(), test_min_size, .CENTER, .CENTER, "CENTER") {
		// test_vertical_alignment = .CENTER
		test_horizontal_alignment = .CENTER
		log.infof("R: %v, C: %v\n", row, 2)
	}
	if mal_layout_button(
		mal_id(),
		mc.Vec2{100, 25},
		.CENTER,
		.CENTER,
		"RIGHT",
	) {
		// test_vertical_alignment = .BOTTOM
		test_horizontal_alignment = .RIGHT
		log.infof("R: %v, C: %v\n", row, 3)
	}
	mal_pop_container()

	//log.info(alh.space)
	//alh2 := mal_horizontal_layout(mc.Rect{0.0, 0.0, 0.0, 0.0}, .LEFT)
	//alh2.vertical_sizing = .END
	//mal_push_container(alh2)

	//if mal_layout_button(mal_id(), mc.Vec2{25, 25}, .END, .END, "TOP") {
	//	test_vertical_alignment = .TOP
	//}

	//log.info(alv.space)
	//if mal_layout_button(
	//	mal_id(),
	//	mc.Vec2{25, 25},
	//	.CENTER,
	//	.CENTER,
	//	"CENTER",
	//) {
	//	test_vertical_alignment = .CENTER
	//}
	//if mal_layout_button(
	//	mal_id(),
	//	mc.Vec2{25, 25},
	//	.CENTER,
	//	.CENTER,
	//	"RIGHT",
	//) {
	//	test_vertical_alignment = .BOTTOM
	//}
	//mal_pop_container()
	mal_pop_container()

}

layout_ui :: proc(delta_time: f32) {
	hl := mal_vertical_layout(
		mc.Rect{500, 0, 0.0, f32(state.screen_height)},
		test_vertical_alignment,
	)
	mal_push_container(hl)

	//vl := mal_vertical_layout(
	//	mc.Rect{600, 0, 200, f32(state.screen_height)},
	//	test_vertical_alignment,
	//)
	//mal_push_container(vl)


	if mal_layout_button(
		mal_id(),
		mc.Vec2{32, 32},
		.CENTER,
		.FILL,
		"First Button",
	) {
		log.info("First button has been hit")
	}

	if mal_layout_button(
		mal_id(),
		test_min_size,
		.CENTER,
		.CENTER,
		"Second Button",
	) {
		log.info("Second button has been hit")
	}

	if mal_layout_button(
		mal_id(),
		mc.Vec2{32, 32},
		.CENTER,
		.CENTER,
		"Third Button",
	) {
		log.info("Third button has been hit")
	}
	mal_pop_container()
	//mal_pop_container()

}

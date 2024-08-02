package mallard

import c "core:c"
import "core:fmt"
import "core:log"
// import "core:math"
import "core:mem"

import mc "./common"

track: mem.Tracking_Allocator

DEFAULT_WINDOW_WIDTH: i32 = 1280
DEFAULT_WINDOW_HEIGHT: i32 = 720
DEFAULT_VIEWPORT_WIDTH: i32 = 960
DEFAULT_VIEWPORT_HEIGHT: i32 = 540
ROOT_CONTAINER: ^Mallard_Container
frame_commands: [dynamic]^Mallard_Render_Command


Mallard_State :: struct {
	viewport_bg_color, component_bg_color:                   mc.Color,
	screen_width, screen_height:                             c.int,
	viewport_x, viewport_y, viewport_width, viewport_height: c.int,
	mouse_position:                                          mc.Vec2,
}

Mallard_Render_Command :: struct {
	draw:     #type proc(el: ^Mallard_Element),
	deinit:   #type proc(el: ^Mallard_Element, allocator: mem.Allocator),
	instance: ^Mallard_Element,
}

state := Mallard_State {
	screen_width = DEFAULT_WINDOW_WIDTH,
	screen_height = DEFAULT_WINDOW_HEIGHT,
	viewport_width = DEFAULT_VIEWPORT_WIDTH,
	viewport_height = DEFAULT_VIEWPORT_HEIGHT,
	viewport_x = DEFAULT_WINDOW_WIDTH / 2 - DEFAULT_VIEWPORT_WIDTH / 2,
	viewport_y = 32,
	component_bg_color = {48, 48, 48, 255},
	viewport_bg_color = {24, 24, 24, 255},
}

main :: proc() {
	mem.tracking_allocator_init(&track, context.allocator)
	context.allocator = mem.tracking_allocator(&track)
	context.logger = log.create_console_logger(log.Level.Info)

	init()

	for !mc._windowShouldClose() {
		delta := mc._getFrameTime()

		clear_commands()

		if mc._isWindowResized() {
			state.screen_width = mc._getScreenWidth()
			state.screen_height = mc._getScreenHeight()
			state.viewport_x = state.screen_width / 2 - state.viewport_width / 2
		}

		update(delta)

		render()
	}


	deinit()
}

render :: proc() {
	mc._beginDrawing()
	{
		mc._clearBackground(state.component_bg_color)

		// element_draw(ROOT_CONTAINER)
		for rc in frame_commands {
			rc.draw(rc.instance)
		}
	}
	mc._endDrawing()
}

init :: proc() {
	log.info("[init]")
	mc._setConfigFlags(
		{mc.ConfigFlag.MSAA_4X_HINT} |
		{mc.ConfigFlag.WINDOW_MAXIMIZED} |
		{mc.ConfigFlag.WINDOW_RESIZABLE},
	)
	mc._initWindow(state.screen_width, state.screen_height, "Mallard")
	mc._setTargetFPS(60)

	editor_font = mc._loadFontEx("./assets/zed-mono/zed-mono-semibold.ttf", i32(32), nil, 0)
	mc._setTextureFilter(editor_font.texture, mc.TextureFilter.BILINEAR)

	frame_commands = make([dynamic]^Mallard_Render_Command)

}

deinit :: proc(allocator := context.allocator) {
	log.info("[deinit]")


	clear_commands()
	delete(frame_commands)

	mc._unloadFont(editor_font)
	mc._closeWindow()

	log.destroy_console_logger(context.logger)
	for _, leak in track.allocation_map {
		fmt.eprintf("%v leaked %v bytes\n", leak.location, leak.size)
	}

	for bad_free in track.bad_free_array {
		fmt.eprintf("%p allocation %p was freed incorrectly\n", bad_free.location, bad_free.memory)
	}
}

update :: proc(delta_time: f32) {
	if mal_button(mc.Rect{50, 50, 96, 32}, "Some Button") {
		log.info("DA BUTTON BEEN HIT")
	}
}

clear_commands :: proc(allocator := context.allocator) {
	defer clear(&frame_commands)
	#reverse for rc in frame_commands {
		rc.deinit(rc.instance, allocator)
		free(rc)
	}
}

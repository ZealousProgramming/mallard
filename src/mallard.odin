package mallard

import c "core:c"
import "core:fmt"
import "core:log"
import "core:math"
import "core:mem"

import mc "./common"

track: mem.Tracking_Allocator

DEFAULT_WINDOW_WIDTH: i32 = 1280
DEFAULT_WINDOW_HEIGHT: i32 = 720
DEFAULT_VIEWPORT_WIDTH: i32 = 960
DEFAULT_VIEWPORT_HEIGHT: i32 = 540
ROOT_CONTAINER: ^Mallard_Container
nav_panel: ^Mallard_Panel


Mallard_State :: struct {
	viewport_bg_color, component_bg_color:                   mc.Color,
	screen_width, screen_height:                             c.int,
	viewport_x, viewport_y, viewport_width, viewport_height: c.int,
	mouse_position:                                          mc.Vec2,
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

viewport_texture: mc.RenderTexture

circle_transform := mc.Xform {
	translation = mc.Vec3{720.0, 480.0, 0.0},
	scale = mc.Vec3{64.0, 0.0, 0.0},
}

main :: proc() {
	mem.tracking_allocator_init(&track, context.allocator)
	context.allocator = mem.tracking_allocator(&track)
	context.logger = log.create_console_logger(log.Level.Info)

	init()

	movement_speed: f32 = 150.0
	growth_speed: f32 = 20.0

	for !mc._windowShouldClose() {
		delta := mc._getFrameTime()

		if mc._isWindowResized() {
			state.screen_width = mc._getScreenWidth()
			state.screen_height = mc._getScreenHeight()
			state.viewport_x = state.screen_width / 2 - state.viewport_width / 2
		}

		if i32(circle_transform.translation.x) > state.screen_width &&
		   math.sign(movement_speed) > 0.0 {
			movement_speed = -1.0 * math.abs(movement_speed)
		} else if i32(circle_transform.translation.x) < 0.0 && math.sign(movement_speed) < 0.0 {
			movement_speed = math.abs(movement_speed)
		}

		if i32(circle_transform.translation.x) > state.screen_width &&
		   math.sign(growth_speed) > 0.0 {
			growth_speed = -1.0 * math.abs(growth_speed)
		} else if i32(circle_transform.translation.x) < 0.0 && math.sign(growth_speed) < 0.0 {
			growth_speed = math.abs(growth_speed)
		}

		circle_transform.translation.x = circle_transform.translation.x + delta * movement_speed
		circle_transform.scale.x = circle_transform.scale.x + delta * growth_speed

		nav_panel.transform.local.x += delta * movement_speed

		update(delta)

		render()
	}


	deinit()
}

render :: proc() {
	mc._beginTextureMode(viewport_texture)
	{
		mc._endScissorMode()
		mc._clearBackground(state.viewport_bg_color)
		mc._drawCircleSector(
			circle_transform.translation.xy,
			circle_transform.scale.x,
			0,
			360,
			64,
			mc.RED,
		)
		mc._drawTextEx(
			editor_font,
			"Inside the viewport",
			{50, 50},
			f32(EDITOR_FONT_SIZE),
			EDITOR_FONT_SPACING,
			mc.WHITE,
		)
	}
	mc._endTextureMode()

	mc._beginDrawing()
	{
		mc._clearBackground(state.component_bg_color)
		mc._drawTextureRec(
			viewport_texture.texture,
			mc.Rect{0, 0, f32(state.viewport_width), -f32(state.viewport_height)},
			mc.Vec2{f32(state.viewport_x), f32(state.viewport_y)},
			mc.WHITE,
		)

		element_draw(ROOT_CONTAINER)
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

	// editor_font = mc._loadFontEx("./assets/roboto/Roboto.ttf", i32(EDITOR_FONT_SIZE), nil, 250)
	editor_font = mc._loadFontEx("./assets/zed-mono/zed-mono-semibold.ttf", i32(32), nil, 0)
	mc._setTextureFilter(editor_font.texture, mc.TextureFilter.BILINEAR)

	// Setup root container
	ROOT_CONTAINER = container_init(
		nil,
		Mallard_Transform {
			global = mc.Vec2{0.0, 0.0},
			local = mc.Vec2{0.0, 0.0},
			size = mc.Vec2{1.0, 1.0},
		},
	)
	viewport_texture = mc._loadRenderTexture(state.viewport_width, state.viewport_height)
	// mc._setTextureFilter(viewport_texture.texture, mc.TextureFilter.BILINEAR)

	button := rounded_button_init(
		ROOT_CONTAINER,
		"Some text",
		Mallard_Transform{local = mc.Vec2{50, 50}, size = mc.Vec2{96, 24}},
		mc.Color{96, 96, 96, 255},
		mc.Color{120, 120, 120, 255},
		12,
		0.2,
		4.0,
	)

	nav_panel = panel_init(
		ROOT_CONTAINER,
		Mallard_Transform{local = mc.Vec2{10, 0}, size = mc.Vec2{48, f32(mc._getScreenHeight())}},
		mc.BLUE,
		// mc.Color{24, 24, 24, 255},
	)

	nav_vert_container := vertical_container_init(
		nav_panel,
		Mallard_Transform{local = mc.Vec2{0.0, 0.0}},
	)
	append(&nav_panel.children, nav_vert_container)

	append(&ROOT_CONTAINER.children, button)
	append(&ROOT_CONTAINER.children, nav_panel)
}

deinit :: proc(allocator := context.allocator) {
	log.info("[deinit]")

	element_deinit(ROOT_CONTAINER, allocator)

	mc._unloadRenderTexture(viewport_texture)
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
	element_update(ROOT_CONTAINER)
	element_position(ROOT_CONTAINER)
}

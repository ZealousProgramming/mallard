package mallard

import q "core:container/queue"
import "core:log"

import mc "./common"

frame_commands: [dynamic]^Mallard_Render_Command
container_stack: q.Queue(^Mallard_Element)
root_container: ^Mallard_Container
frame_data: map[string]^Mallard_Element

state := Mallard_State {
	screen_width       = DEFAULT_WINDOW_WIDTH,
	screen_height      = DEFAULT_WINDOW_HEIGHT,
	viewport_width     = DEFAULT_VIEWPORT_WIDTH,
	viewport_height    = DEFAULT_VIEWPORT_HEIGHT,
	viewport_x         = DEFAULT_WINDOW_WIDTH / 2 - DEFAULT_VIEWPORT_WIDTH / 2,
	viewport_y         = 32,
	component_bg_color = {48, 48, 48, 255},
	viewport_bg_color  = {24, 24, 24, 255},
	input_state        = {},
}

mal_init :: proc() {
	log.info("[Mallard][init]")

	editor_font = mc._loadFontEx(
		"./assets/zed-mono/zed-mono-semibold.ttf",
		i32(32),
		nil,
		0,
	)
	mc._setTextureFilter(editor_font.texture, mc.TextureFilter.BILINEAR)

	q.init(&container_stack)
	frame_commands = make([dynamic]^Mallard_Render_Command)

}

mal_begin_frame :: proc() {
	mal_clear_commands()
	q.clear(&container_stack)

	root_container = mal_layout(
		mc.Rect{0, 0, f32(state.screen_width), f32(state.screen_height)},
	)
	mal_push_container(root_container)
}

mal_end_frame :: proc() {
	state.input_state.mouse_position = get_mouse_position()
	if is_mouse_button_released(mc.MouseButton.LEFT) {
		state.input_state.mouse_left = .RELEASED
	} else if is_mouse_button_pressed(mc.MouseButton.LEFT) {
		state.input_state.mouse_left = .PRESSED
	} else if is_mouse_button_down(mc.MouseButton.LEFT) {
		state.input_state.mouse_left = .DOWN
	} else {
		state.input_state.mouse_left = .NIL
	}

	mal_build_layout()
	mal_render()
}

mal_resized :: proc(new_size: [2]i32) {
	state.screen_width = new_size.x
	state.screen_height = new_size.y
	state.viewport_x = state.screen_width / 2 - state.viewport_width / 2
}

mal_deinit :: proc() {
	log.info("[Mallard][deinit]")

	mal_delete_id(state.hot_element_id)
	mal_delete_id(state.active_element_id)

	mal_clear_commands()
	delete(frame_commands)

	q.destroy(&container_stack)

	mc._unloadFont(editor_font)
}

mal_render :: proc() {
	mc._beginDrawing()
	{
		mc._clearBackground(state.component_bg_color)

		for rc in frame_commands {
			if rc.draw == nil {continue}
			rc.draw(rc.instance)
		}

		// mc._drawTexture(cog_texture, 100, 100, DEFAULT_THEME.accent)
	}
	mc._endDrawing()
}

mal_clear_commands :: proc(allocator := context.allocator) {
	defer clear(&frame_commands)
	#reverse for rc in frame_commands {
		rc.deinit(rc.instance, allocator)
		free(rc)
	}
}

mal_build_layout :: proc() {
	mal_layout_calculate(root_container)
}

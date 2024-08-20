package mallard


import q "core:container/queue"
//import "core:log"
import "core:strings"

import mc "./common"
import rl "vendor:raylib"

// --- Button Types ----
// mal_button: Standard Button with text
// mal_icon_button: Standard Button with an icon rather than text
// mal_checkbox: A button with a fillable box (checkmark/block)

button_free :: proc(self: ^Mallard_Element, allocator := context.allocator) {
	el, _ := element_variant(self, Mallard_Button)
	if el.id != "" {
		mal_delete_id(el.id)
	}

	if el.text != nil {
		delete(el.text)
	}

	free(self, allocator)
}

button_draw :: proc(self: ^Mallard_Element) {
	if DRAW_ONLY_LAYOUTS {return}

	el, _ := element_variant(self, Mallard_Button)
	gp := element_recalculate_global_position(el)

	color := rl.PINK
	switch el.state {
	case .NORMAL:
		color = el.style.normal_color
	case .HOVER:
		color = el.style.hover_color
	case .DOWN:
		color = el.style.pressed_color
	}
	rl.DrawRectangleRounded(
		mc.Rect{gp.x, gp.y, el.rect.width, el.rect.height},
		//el.rect,
		el.style.roundness,
		i32(el.style.segments),
		color,
	)
	if DRAW_DEBUG_BOX {
		rl.DrawRectangleRounded(
			mc.Rect{gp.x, gp.y, el.min_size.x, el.min_size.y},
			el.style.roundness,
			i32(el.style.segments),
			DEBUG_BOUNDING_BOX_COLOR,
		)
	}

	if el.text == nil {return}
	text_size := mc._measureTextEx(
		editor_font,
		el.text,
		f32(EDITOR_FONT_SIZE),
		EDITOR_FONT_SPACING,
	)
	label_x := gp.x + el.rect.width * 0.5 - text_size.x * 0.5
	label_y := gp.y + el.rect.height * 0.5 - text_size.y * 0.5

	// mc._drawTextEx(
	// 	editor_font,
	// 	el.text,
	// 	{label_x, label_y + 1},
	// 	f32(EDITOR_FONT_SIZE),
	// 	EDITOR_FONT_SPACING,
	// 	mc.Color{16, 16, 16, 255},
	// )
	mc._drawTextEx(
		editor_font,
		el.text,
		{label_x, label_y},
		f32(EDITOR_FONT_SIZE),
		EDITOR_FONT_SPACING,
		el.style.text_color,
	)
}

mal_button :: proc(
	id: Mallard_Id,
	min_size: mc.Vec2,
	vertical: Mallard_Sizing_Behavior,
	horizontal: Mallard_Sizing_Behavior,
	t: string,
	style := DEFAULT_BUTTON_STYLE,
	allocator := context.allocator,
) -> bool {
	b := new(Mallard_Button, allocator)

	b.id = id
	b.variant = b
	b.style = style
	b.horizontal_sizing = horizontal
	b.vertical_sizing = vertical
	b.min_size = min_size
	b.text, _ = strings.clone_to_cstring(t)
	text_size := mc._measureTextEx(
		editor_font,
		b.text,
		f32(EDITOR_FONT_SIZE),
		EDITOR_FONT_SPACING,
	)

	desired_size := mc.Vec2 {
		text_size.x + style.padding.x * 2,
		text_size.y + style.padding.y * 2,
	}
	desired_position := mc.Vec2{0.0, 0.0}
	button_determine_desired_size(b, &desired_size)

	b.rect = mc.Rect {
		desired_position.x,
		desired_position.y,
		desired_size.x,
		desired_size.y,
	}

	if q.len(container_stack) > 0 {
		container := q.peek_back(&container_stack)^
		append(&container.children, b)
		b.container = container
	}

	rc := new(Mallard_Render_Command, allocator)
	rc.draw = button_draw
	rc.deinit = button_free
	rc.instance = b

	append(&frame_commands, rc)

	return button_state_update(b)
}

button_determine_desired_size :: proc(
	b: ^Mallard_Button,
	desired_size: ^mc.Vec2,
) {
	if b.min_size.x > desired_size.x {
		desired_size.x = b.min_size.x
	} else {
		b.min_size.x = desired_size.x
	}

	if b.min_size.y > desired_size.y {
		desired_size.y = b.min_size.y
	} else {
		b.min_size.y = desired_size.y
	}

}

button_state_update :: proc(b: ^Mallard_Button) -> bool {
	execute_callback := false
	if state.active_element_id == b.id {
		b.state = .DOWN
	} else if state.hot_element_id == b.id {
		b.state = .HOVER

		// NOTE(devon): The release will already have knocked it from active, which is why it'll still be hot
		execute_callback = state.input_state.mouse_left == .RELEASED
	}

	return execute_callback
}

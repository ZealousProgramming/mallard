package mallard


import q "core:container/queue"
// import "core:log"
import "core:strings"

import mc "./common"
import rl "vendor:raylib"

Mallard_Button_Style :: struct {
	normal_color:   rl.Color,
	hover_color:    rl.Color,
	pressed_color:  mc.Color,
	text_color:     mc.Color,
	padding:        mc.Vec2,
	segments:       int,
	roundness:      f32,
	line_thickness: f32,
	is_rounded:     bool,
}

button_free :: proc(self: ^Mallard_Element, allocator := context.allocator) {
	el, _ := element_variant(self, Mallard_Button)
	if el.hash != "" {
		delete(el.hash)
	}

	if el.text != nil {
		delete(el.text)
	}

	free(self, allocator)
}

button_draw :: proc(self: ^Mallard_Element) {
	el, _ := element_variant(self, Mallard_Button)

	color := rl.PINK
	switch el.state {
	case .NORMAL:
		color = el.style.normal_color
	case .HOVER:
		color = el.style.hover_color
	case .SELECTED:
		color = el.style.pressed_color
	}
	rl.DrawRectangleRounded(
		el.rect,
		el.style.roundness,
		i32(el.style.segments),
		color,
	)
	if DRAW_DEBUG_BOX {
		rl.DrawRectangleRounded(
			mc.Rect{el.rect.x, el.rect.y, el.min_size.x, el.min_size.y},
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
	label_x := el.rect.x + el.rect.width * 0.5 - text_size.x * 0.5
	label_y := el.rect.y + el.rect.height * 0.5 - text_size.y * 0.5

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

mal_layout_button :: proc(
	hash: string,
	min_size: mc.Vec2,
	vertical: Mallard_Sizing_Behavior,
	horizontal: Mallard_Sizing_Behavior,
	t: string,
	style := DEFAULT_BUTTON_STYLE,
	allocator := context.allocator,
) -> bool {
	b := new(Mallard_Button, allocator)

	b.hash = hash
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

	if q.len(container_stack) > 0 {
		container := q.peek_back(&container_stack)^
		append(&container.children, b)
		b.container = container

		mal_container_size_check(container, b.min_size)
	}

	b.rect = mc.Rect {
		desired_position.x + state.stack_position.x,
		desired_position.y + state.stack_position.y,
		desired_size.x,
		desired_size.y,
	}

	rc := new(Mallard_Render_Command, allocator)
	rc.draw = button_draw
	rc.deinit = button_free
	rc.instance = b

	append(&frame_commands, rc)

	under_mouse := is_element_under_mouse(b.rect)
	clicked :=
		is_mouse_button_pressed(mc.MouseButton.LEFT) ||
		is_mouse_button_down(mc.MouseButton.LEFT)

	if under_mouse && clicked {
		b.state = .SELECTED
	} else if under_mouse && !clicked {
		b.state = .HOVER
	} else {
		b.state = .NORMAL
	}

	return b.state == .SELECTED
}

mal_button :: proc(
	position: mc.Vec2,
	min_size: mc.Vec2,
	t: string,
	style := DEFAULT_BUTTON_STYLE,
	allocator := context.allocator,
) -> bool {
	b := new(Mallard_Button, allocator)

	b.variant = b
	b.style = style
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

	b.rect = mc.Rect {
		position.x + state.stack_position.x,
		position.y + state.stack_position.y,
		b.min_size.x if b.min_size.x > desired_size.x else desired_size.x,
		b.min_size.y if b.min_size.y > desired_size.y else desired_size.y,
	}

	// mal_container_size_check(b.min_size)

	rc := new(Mallard_Render_Command, allocator)
	rc.draw = button_draw
	rc.deinit = button_free
	rc.instance = b

	append(&frame_commands, rc)

	element_interaction(b)

	return b.state == .SELECTED
}

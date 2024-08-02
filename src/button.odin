package mallard

import mc "./common"
import "core:strings"
import rl "vendor:raylib"

Mallard_Button_Style :: struct {
	normal_color:   rl.Color,
	hover_color:    rl.Color,
	segments:       int,
	roundness:      f32,
	line_thickness: f32,
	is_rounded:     bool,
}

button_init :: proc(
	container: ^Mallard_Element,
	label: string,
	transform: Mallard_Transform,
	background_color: rl.Color,
	hover_color: rl.Color,
	allocator := context.allocator,
) -> ^Mallard_Button {
	b := new(Mallard_Button, allocator)

	b.container = container
	b.variant = b
	b.transform = transform
	b.transform.global = transform.local
	b.style = Mallard_Button_Style {
		normal_color = background_color,
		hover_color  = hover_color,
	}
	// b.current_color = background_color
	b.state = .NORMAL


	// VTable
	b.vtable = new(Mallard_Element_VTable, allocator)
	b.vtable.deinit = button_free
	b.vtable.update = button_update
	b.vtable.draw = button_draw

	b.label = new(Mallard_Label, allocator)
	b.label.text, _ = strings.clone_to_cstring(label, allocator)
	b.label.allocated = true
	b.label.foreground_color = mc.WHITE

	return b
}

rounded_button_init :: proc(
	container: ^Mallard_Element,
	label: string,
	transform: Mallard_Transform,
	background_color: rl.Color,
	hover_color: rl.Color,
	segments: int,
	roundness: f32,
	line_thickness: f32,
	allocator := context.allocator,
) -> ^Mallard_Button {
	b := button_init(container, label, transform, background_color, hover_color, allocator)

	b.style.segments = segments
	b.style.roundness = roundness
	b.style.line_thickness = line_thickness
	b.style.is_rounded = true

	return b
}

button_free :: proc(self: ^Mallard_Element, allocator := context.allocator) {
	// el, _ := element_variant(self, Mallard_Button)
	// if el.label != nil {
	// 	delete(el.label.text)
	// 	free(el.label, allocator)
	// }

	free(self, allocator)
}

button_update :: proc(self: ^Mallard_Element) {
	el, _ := element_variant(self, Mallard_Button)

	if is_element_under_mouse(element_rect(el)) {
		el.state = .HOVER
	} else {
		el.state = .NORMAL
	}
}

button_draw :: proc(self: ^Mallard_Element) {
	el, _ := element_variant(self, Mallard_Button)

	// rect := element_rect(el)
	rect := el.rect
	color := rl.PINK
	switch el.state {
	case .NORMAL:
		color = el.style.normal_color
	case .HOVER:
		color = el.style.hover_color
	case .SELECTED:
		color = mc.WHITE
	}
	rl.DrawRectangleRounded(rect, el.style.roundness, i32(el.style.segments), color)
	// rl.DrawRectangleRoundedLines(rect, el.roundness, i32(el.segments), el.line_thickness, color)

	if el.label == nil {return}
	text_size := mc._measureTextEx(
		editor_font,
		el.label.text,
		f32(EDITOR_FONT_SIZE),
		EDITOR_FONT_SPACING,
	)
	label_x := el.transform.global.x + el.transform.size.x * 0.5 - text_size.x * 0.5
	label_y := el.transform.global.y + el.transform.size.y * 0.5 - text_size.y * 0.5

	// mc._drawTextEx(
	// 	editor_font,
	// 	el.label.text,
	// 	{label_x, label_y + 1},
	// 	f32(EDITOR_FONT_SIZE),
	// 	EDITOR_FONT_SPACING,
	// 	mc.BLACK,
	// )
	mc._drawTextEx(
		editor_font,
		el.label.text,
		{label_x, label_y},
		f32(EDITOR_FONT_SIZE),
		EDITOR_FONT_SPACING,
		el.label.foreground_color,
	)
}

mal_button :: proc(
	rect: mc.Rect,
	t: cstring,
	style := DEFAULT_BUTTON_STYLE,
	allocator := context.allocator,
) -> bool {
	b := new(Mallard_Button, allocator)

	b.variant = b
	b.style = style
	b.rect = rect


	rc := new(Mallard_Render_Command, allocator)
	rc.draw = button_draw
	rc.deinit = button_free
	rc.instance = b

	append(&frame_commands, rc)

	under_mouse := is_element_under_mouse(rect)
	clicked := is_mouse_button_pressed(mc.MouseButton.LEFT)

	if under_mouse && clicked {
		b.state = .SELECTED
	} else if under_mouse && !clicked {
		b.state = .HOVER
	} else {
		b.state = .NORMAL
	}

	return b.state == .SELECTED
}

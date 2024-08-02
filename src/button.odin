package mallard

import mc "./common"
import "core:strings"
import rl "vendor:raylib"

button_init :: proc(
	container: ^Mallard_Transform,
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
	b.normal_color = background_color
	b.hover_color = hover_color
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
	container: ^Mallard_Transform,
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
	b.segments = segments
	b.roundness = roundness
	b.line_thickness = line_thickness
	b.is_rounded = true

	return b
}

button_free :: proc(self: ^Mallard_Element, allocator := context.allocator) {
	el, _ := element_variant(self, Mallard_Button)
	if el.label != nil {
		delete(el.label.text)
		free(el.label, allocator)
	}

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

	rect := element_rect(el)
	color := rl.PINK
	switch el.state {
	case .NORMAL:
		color = el.normal_color
	case .HOVER:
		color = el.hover_color
	case .SELECTED:
		color = mc.WHITE
	}
	rl.DrawRectangleRounded(rect, el.roundness, i32(el.segments), color)
	// rl.DrawRectangleRoundedLines(rect, el.roundness, i32(el.segments), el.line_thickness, color)

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

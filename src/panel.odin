package mallard

import rl "vendor:raylib"

panel_init :: proc(
	container: ^Mallard_Transform,
	transform: Mallard_Transform,
	background_color: rl.Color,
	allocator := context.allocator,
) -> ^Mallard_Panel {
	p := new(Mallard_Panel, allocator)

	p.container = container
	p.variant = p
	p.transform = transform
	p.transform.global = transform.local

	// VTable
	p.vtable = new(Mallard_Element_VTable, allocator)
	p.vtable.deinit = panel_free
	p.vtable.update = nil
	p.vtable.draw = panel_draw

	return p
}


panel_free :: proc(self: ^Mallard_Element, allocator := context.allocator) {
	// el, _ := element_variant(self, Mallard_Panel)

	free(self, allocator)
}

panel_draw :: proc(self: ^Mallard_Element) {
	el, _ := element_variant(self, Mallard_Panel)

	rect := element_rect(el)
	rl.DrawRectangleRec(rect, el.background_color)
	// rl.DrawRectangleRounded(rect, el.roundness, i32(el.segments), color)
	// rl.DrawRectangleRoundedLines(rect, el.roundness, i32(el.segments), el.line_thickness, color)
}

package mallard


// panel_init :: proc(
// 	container: ^Mallard_Element,
// 	transform: Mallard_Transform,
// 	background_color: rl.Color,
// 	allocator := context.allocator,
// ) -> ^Mallard_Panel {
// 	p := new(Mallard_Panel, allocator)

// 	p.container = container
// 	p.variant = p
// 	p.transform = transform
// 	p.transform.global = transform.local
// 	p.background_color = background_color

// 	// VTable
// 	p.vtable = new(Mallard_Element_VTable, allocator)
// 	p.vtable.deinit = element_basic_deinit
// 	p.vtable.update = nil
// 	p.vtable.draw = panel_draw

// 	return p
// }

// panel_draw :: proc(self: ^Mallard_Element) {
// 	el, _ := element_variant(self, Mallard_Panel)

// 	rect := element_rect(el)
// 	rl.DrawRectangleRec(rect, el.background_color)
// 	// rl.DrawRectangleRounded(rect, el.roundness, i32(el.segments), color)
// 	// rl.DrawRectangleRoundedLines(rect, el.roundness, i32(el.segments), el.line_thickness, color)
// }

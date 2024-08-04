package mallard

import mc "./common"


// container_init :: proc(
// 	container: ^Mallard_Element,
// 	transform: Mallard_Transform,
// 	allocator := context.allocator,
// ) -> ^Mallard_Container {
// 	p := new(Mallard_Container, allocator)

// 	p.children = make([dynamic]^Mallard_Element, allocator)
// 	p.container = container
// 	p.variant = p
// 	p.transform = transform
// 	p.transform.global = transform.local

// 	// VTable
// 	p.vtable = new(Mallard_Element_VTable, allocator)
// 	p.vtable.deinit = element_basic_deinit
// 	p.vtable.update = nil
// 	p.vtable.draw = nil

// 	return p
// }


// vertical_container_init :: proc(
// 	container: ^Mallard_Element,
// 	transform: Mallard_Transform,
// 	fill := true,
// 	allocator := context.allocator,
// ) -> ^Mallard_Vertical_Container {
// 	p := new(Mallard_Vertical_Container, allocator)

// 	p.container = container
// 	p.variant = p
// 	p.transform = transform
// 	p.transform.global = transform.local
// 	p.fill = fill

// 	if container != nil {
// 		p.transform.global = transform.local + element_recalculate_global_position(container)
// 		if fill {
// 			p.transform.size = container.transform.size
// 		}
// 	}


// 	// VTable
// 	p.vtable = new(Mallard_Element_VTable, allocator)
// 	p.vtable.deinit = element_basic_deinit
// 	p.vtable.update = nil
// 	p.vtable.draw = vertical_container_draw

// 	return p
// }

vertical_container_draw :: proc(self: ^Mallard_Element) {
	mc._drawRectLinesEx(
	   self.rect,
		2.0,
		DEBUG_BOUNDING_BOX_COLOR,
	)
}

mal_vertical_layout :: proc(
	rect: mc.Rect,
	alignment: Mallard_Vertical_Alignment,
	allocator := context.allocator,
) -> ^Mallard_Vertical_Container {
	b := new(Mallard_Vertical_Container, allocator)

	b.variant = b
	b.rect = rect
	b.rect.x += state.stack_position.x
	b.rect.y += state.stack_position.y

	rc := new(Mallard_Render_Command, allocator)
	rc.draw = vertical_container_draw
	rc.deinit = element_basic_deinit
	rc.instance = b

	append(&frame_commands, rc)

	return b
}

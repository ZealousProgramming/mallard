package mallard

import mc "./common"

container_init :: proc(
	container: ^Mallard_Element,
	transform: Mallard_Transform,
	allocator := context.allocator,
) -> ^Mallard_Container {
	p := new(Mallard_Container, allocator)

	p.children = make([dynamic]^Mallard_Element, allocator)
	p.container = container
	p.variant = p
	p.transform = transform
	p.transform.global = transform.local

	// VTable
	p.vtable = new(Mallard_Element_VTable, allocator)
	p.vtable.deinit = element_basic_deinit
	p.vtable.update = nil
	p.vtable.draw = nil

	return p
}


vertical_container_init :: proc(
	container: ^Mallard_Element,
	transform: Mallard_Transform,
	fill := true,
	allocator := context.allocator,
) -> ^Mallard_Vertical_Container {
	p := new(Mallard_Vertical_Container, allocator)

	p.container = container
	p.variant = p
	p.transform = transform
	p.transform.global = transform.local
	p.fill = fill

	if container != nil {
		p.transform.global = transform.local + element_recalculate_global_position(container)
		if fill {
			p.transform.size = container.transform.size
		}
	}


	// VTable
	p.vtable = new(Mallard_Element_VTable, allocator)
	p.vtable.deinit = element_basic_deinit
	p.vtable.update = nil
	p.vtable.draw = vertical_container_draw

	return p
}

vertical_container_draw :: proc(self: ^Mallard_Element) {
	mc._drawRectLines(
		i32(self.transform.global.x),
		i32(self.transform.global.y),
		i32(self.transform.size.x),
		i32(self.transform.size.y),
		DEBUG_BOUNDING_BOX_COLOR,
	)
}

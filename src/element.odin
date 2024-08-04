package mallard

import mc "./common"
import q "core:container/queue"


// element_update :: proc(el: ^Mallard_Element, allocator := context.allocator) {
// 	if el == nil {return}
// 	if el.children != nil && len(el.children) > 0 {
// 		for c in el.children {
// 			element_update(c, allocator)
// 		}
// 	}

// 	if el.update != nil {
// 		el->update()
// 	}
// }

// element_draw :: proc(el: ^Mallard_Element, allocator := context.allocator) {
// 	if el == nil {return}

// 	if el.draw != nil {
// 		el->draw()
// 	}

// 	if el.children != nil && len(el.children) > 0 {
// 		for c in el.children {
// 			element_draw(c, allocator)
// 		}
// 	}


// }

// element_deinit :: proc(el: ^Mallard_Element, allocator := context.allocator) {
// 	if el == nil {return}

// 	if el.children != nil && len(el.children) > 0 {
// 		for c in el.children {
// 			element_deinit(c, allocator)
// 		}

// 		delete(el.children)
// 	}

// 	if el.deinit != nil {
// 		free(el.vtable, allocator)
// 		el->deinit(allocator)
// 	}
// }

element_variant :: proc(el: ^Mallard_Element, $T: typeid) -> (^T, Mallard_Ui_Error) {
	if el == nil {return nil, .TYPE_NOT_FOUND}

	#partial switch el in el.variant {
	case ^T:
		{
			return el, .NIL
		}
	}

	return nil, .TYPE_NOT_FOUND
}

element_basic_deinit :: proc(self: ^Mallard_Element, allocator := context.allocator) {
	free(self, allocator)
}

mal_push_container :: proc(container: ^Mallard_Element) {
	q.append(&container_stack, container)
	state.stack_position += mc.Vec2{container.rect.x, container.rect.y}
}

mal_pop_container :: proc() {
	c := q.pop_back(&container_stack)
	state.stack_position -= mc.Vec2{c.rect.x, c.rect.y}
}

mal_container_size_check :: proc(size: mc.Vec2) {
	if q.len(container_stack) <= 0 {return}

	container := q.peek_back(&container_stack)^

	if container.rect.width < size.x {
		container.rect.width = size.x
	}

	if container.rect.height < size.y {
		container.rect.height = size.y
	}
}


// element_rect :: proc(el: ^Mallard_Element) -> mc.Rect {
// 	if el == nil {return mc.Rect{}}
// 	gp := el.transform.global
// 	sz := el.transform.size
// 	return mc.Rect{gp.x, gp.y, sz.x, sz.y}
// }

// element_position :: proc(el: ^Mallard_Element) {
// 	if el == nil {return}
// 	for c in el.children {
// 		c.transform.global.x = c.transform.local.x + el.transform.global.x
// 		c.transform.global.y = c.transform.local.y + el.transform.global.y

// 		if len(c.children) == 0 {continue}

// 		element_position(c)
// 	}
// }


// element_recalculate_global_position :: proc(self: ^Mallard_Element) -> mc.Vec2 {
// 	if self.container == nil {
// 		return self.transform.local
// 	}

// 	container_p := element_recalculate_global_position(self.container)

// 	return self.transform.local + container_p
// }

is_element_under_mouse :: proc(r: mc.Rect) -> bool {
	mouse_position := get_mouse_position()

	mouse_collider_size: f32 = 2.0
	mouse_rect := mc.Rect {
		mouse_position.x - mouse_collider_size,
		mouse_position.y - mouse_collider_size,
		mouse_collider_size * 2,
		mouse_collider_size * 2,
	}

	return mc._checkCollisionRecs(r, mouse_rect)

}

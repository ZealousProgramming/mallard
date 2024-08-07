package mallard

import mc "./common"
import q "core:container/queue"
import "core:fmt"
//import "core:log"
import "core:strings"


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

element_variant :: proc(
	el: ^Mallard_Element,
	$T: typeid,
) -> (
	^T,
	Mallard_Ui_Error,
) {
	if el == nil {return nil, .TYPE_NOT_FOUND}

	#partial switch el in el.variant {
	case ^T:
		{
			return el, .NIL
		}
	}

	return nil, .TYPE_NOT_FOUND
}

element_basic_deinit :: proc(
	self: ^Mallard_Element,
	allocator := context.allocator,
) {
	if self == nil {return}

	if self.children != nil {
		delete(self.children)
	}

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

mal_container_size_check :: proc(container: ^Mallard_Element, size: mc.Vec2) {
	if container == nil {return}
	// if q.len(container_stack) <= 0 {return}
	// container := q.peek_back(&container_stack)^

	if container.rect.width < size.x {
		container.rect.width = size.x
	}

	if container.rect.height < size.y {
		container.rect.height = size.y
	}


	#partial switch v in container.variant {
	case ^Mallard_Container:
		{
			v.space = mc.Vec2{container.rect.width, container.rect.height}
		}
	case ^Mallard_Vertical_Container:
		{
			v.space = mc.Vec2{container.rect.width, container.rect.height}
		}
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


element_recalculate_global_position :: proc(
	self: ^Mallard_Element,
) -> mc.Vec2 {
	if self == nil {return mc.Vec2{0.0, 0.0}}
	current := mc.Vec2{self.rect.x, self.rect.y}
	if self.container == nil {
		return current
	}

	container_p := element_recalculate_global_position(self.container)

	return current + container_p
}

element_global_rect :: proc(self: ^Mallard_Element) -> mc.Rect {
	if self == nil {return mc.Rect{}}

	gp := element_recalculate_global_position(self)
	return mc.Rect{gp.x, gp.y, self.rect.width, self.rect.height}
}

element_calculate_used_space_vertical :: proc(self: ^Mallard_Element) -> f32 {
	if self == nil ||
	   self.children == nil ||
	   len(self.children) == 0 {return 0.0}

	spaced_used: f32 = 0.0
	#partial switch v in self.variant {
	case ^Mallard_Vertical_Container:
		{
			for c in v.children {
				spaced_used += c.rect.height + v.padding
			}
		}
	}

	return spaced_used
}

element_calculate_used_space_horizontal :: proc(
	self: ^Mallard_Element,
) -> f32 {
	if self == nil ||
	   self.children == nil ||
	   len(self.children) == 0 {return 0.0}

	spaced_used: f32 = 0.0
	#partial switch v in self.variant {
	case ^Mallard_Horizontal_Container:
		{
			for c in v.children {
				spaced_used += c.rect.width + v.padding
			}
		}
	}

	return spaced_used
}

element_interaction :: proc(self: ^Mallard_Element) {
	#partial switch v in self.variant {
	case ^Mallard_Button:
		{
			under_mouse := is_element_under_mouse(v.rect)
			clicked :=
				state.input_state.mouse_left == .PRESSED ||
				state.input_state.mouse_left == .DOWN
			released := state.input_state.mouse_left == .RELEASED

			if under_mouse && clicked && state.active_element_id != v.id {
				mal_active_element(v.id)
				//log.infof("Active Element: %v\n", state.active_element_id)
			} else if under_mouse && state.hot_element_id != v.id {
				mal_hot_element(v.id)
				//log.infof("Hot Element: %v\n", state.hot_element_id)
			} else if !clicked && released && state.active_element_id == v.id {
				mal_active_element("")
				//log.infof("Active Element: %v\n", state.active_element_id)
			} else if !under_mouse &&
			   !clicked &&
			   state.hot_element_id == v.id {
				mal_hot_element("")
			}


		}
	}
}

is_element_under_mouse :: proc(r: mc.Rect) -> bool {
	mouse_position := state.input_state.mouse_position

	mouse_collider_size: f32 = 2.0
	mouse_rect := mc.Rect {
		mouse_position.x - mouse_collider_size,
		mouse_position.y - mouse_collider_size,
		mouse_collider_size * 2,
		mouse_collider_size * 2,
	}

	return mc._checkCollisionRecs(r, mouse_rect)

}

mal_id :: #force_inline proc(
	index: int = 0,
	allocator := context.allocator,
	location := #caller_location,
) -> Mallard_Id {
	asd := Mallard_Id(
		fmt.aprintf("%v-%v-%v", location.file_path, location.line, index),
	)

	return asd
}

mal_hot_element :: proc(new_id: Mallard_Id, allocator := context.allocator) {
	if state.hot_element_id != "" {
		mal_delete_id(state.hot_element_id)
	}
	state.hot_element_id =
	cast(Mallard_Id)strings.clone_from(cast(string)new_id)
}

mal_active_element :: proc(
	new_id: Mallard_Id,
	allocator := context.allocator,
) {
	if state.active_element_id != "" {
		mal_delete_id(state.active_element_id)
	}
	state.active_element_id =
	cast(Mallard_Id)strings.clone_from(cast(string)new_id)
}


mal_delete_id :: proc(id: Mallard_Id) {
	delete(cast(string)id)
}

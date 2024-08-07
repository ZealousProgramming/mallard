package mallard

import q "core:container/queue"
import "core:log"

import mc "./common"

container_draw :: proc(self: ^Mallard_Element) {
	mc._drawRectLinesEx(self.rect, 2.0, DEBUG_BOUNDING_BOX_COLOR)
}

mal_layout :: proc(
	rect: mc.Rect,
	allocator := context.allocator,
) -> ^Mallard_Container {
	b := new(Mallard_Container, allocator)

	b.variant = b
	b.rect = rect
	b.rect.x += state.stack_position.x
	b.rect.y += state.stack_position.y

	if q.len(container_stack) > 0 {
		container := q.peek_back(&container_stack)^
		append(&container.children, b)
		b.container = container

	}

	rc := new(Mallard_Render_Command, allocator)
	rc.draw = container_draw
	rc.deinit = element_basic_deinit
	rc.instance = b

	append(&frame_commands, rc)

	return b
}

mal_vertical_layout :: proc(
	rect: mc.Rect,
	alignment: Mallard_Vertical_Alignment,
	allocator := context.allocator,
) -> ^Mallard_Vertical_Container {
	b := new(Mallard_Vertical_Container, allocator)

	b.variant = b
	b.alignment = alignment
	b.rect = rect
	b.rect.x += state.stack_position.x
	b.rect.y += state.stack_position.y
	b.space.x = rect.width
	b.space.y = rect.height

	b.padding = 5.0

	if q.len(container_stack) > 0 {
		container := q.peek_back(&container_stack)^
		append(&container.children, b)
		b.container = container
	}

	rc := new(Mallard_Render_Command, allocator)
	rc.draw = container_draw
	rc.deinit = element_basic_deinit
	rc.instance = b

	append(&frame_commands, rc)

	return b
}

mal_horizontal_layout :: proc(
	rect: mc.Rect,
	alignment: Mallard_Horizontal_Alignment,
	allocator := context.allocator,
) -> ^Mallard_Horizontal_Container {
	b := new(Mallard_Horizontal_Container, allocator)

	b.variant = b
	b.alignment = alignment
	b.rect = rect
	b.rect.x += state.stack_position.x
	b.rect.y += state.stack_position.y
	b.space.x = rect.width
	b.space.y = rect.height

	b.padding = 5.0

	if q.len(container_stack) > 0 {
		container := q.peek_back(&container_stack)^
		append(&container.children, b)
		b.container = container
	}

	rc := new(Mallard_Render_Command, allocator)
	rc.draw = container_draw
	rc.deinit = element_basic_deinit
	rc.instance = b

	append(&frame_commands, rc)

	return b
}


mal_vertical_layout_calculate :: proc(self: ^Mallard_Vertical_Container) {
	if self == nil {return}
	if self.children == nil || len(self.children) == 0 {return}

	// Find out the container's size
	// for c in self.children {
	// 	mal_container_size_check(self, c.min_size)
	// }

	// Cycle through children and divy up the self.space
	global_offset: mc.Vec2 = element_recalculate_global_position(self)

	offset := mc.Vec2{0.0, 0.0}

	switch self.alignment {
	case .TOP:
		{
			for c, _ in self.children {
				#partial switch v in c.variant {
				case ^Mallard_Vertical_Container:
					{
						mal_vertical_layout_calculate(v)
						continue
					}
				case ^Mallard_Horizontal_Container:
					{
						mal_horizontal_layout_calculate(v)
						continue
					}
				}
				desired_size := mc.Vec2{c.rect.width, c.rect.height}
				desired_position := mc.Vec2{0.0, 0.0}

				determine_horizontal_sizing(
					c,
					self,
					&desired_position,
					&desired_size,
				)

				desired_position.y += offset.y
				offset.y += c.min_size.y + self.padding

				c.rect = mc.Rect {
					desired_position.x + global_offset.x,
					desired_position.y + global_offset.y,
					desired_size.x,
					desired_size.y,
				}

				element_interaction(c)
			}

		}
	case .CENTER:
		{
			space_used := element_calculate_used_space_vertical(self)

			for c, _ in self.children {
				#partial switch v in c.variant {
				case ^Mallard_Vertical_Container:
					{
						mal_vertical_layout_calculate(v)
						continue
					}
				case ^Mallard_Horizontal_Container:
					{
						mal_horizontal_layout_calculate(v)
						continue
					}
				}
				desired_size := mc.Vec2{c.rect.width, c.rect.height}
				desired_position := mc.Vec2 {
					0.0,
					self.rect.height / 2.0 - space_used / 2.0,
				}

				determine_horizontal_sizing(
					c,
					self,
					&desired_position,
					&desired_size,
				)

				desired_position.y += offset.y
				offset.y += c.min_size.y + self.padding

				c.rect = mc.Rect {
					desired_position.x + global_offset.x,
					desired_position.y + global_offset.y,
					desired_size.x,
					desired_size.y,
				}

				element_interaction(c)
			}
		}
	case .BOTTOM:
		{
			#reverse for c, _ in self.children {
				#partial switch v in c.variant {
				case ^Mallard_Vertical_Container:
					{
						mal_vertical_layout_calculate(v)
						continue
					}
				case ^Mallard_Horizontal_Container:
					{
						mal_horizontal_layout_calculate(v)
						continue
					}
				}
				desired_size := mc.Vec2{c.rect.width, c.rect.height}
				desired_position := mc.Vec2 {
					0.0,
					self.rect.height - desired_size.y,
				}

				determine_horizontal_sizing(
					c,
					self,
					&desired_position,
					&desired_size,
				)

				desired_position.y += offset.y
				offset.y -= c.min_size.y + self.padding

				c.rect = mc.Rect {
					desired_position.x + global_offset.x,
					desired_position.y + global_offset.y,
					desired_size.x,
					desired_size.y,
				}

				element_interaction(c)
			}
		}


	}

}

mal_horizontal_layout_calculate :: proc(self: ^Mallard_Horizontal_Container) {
	if self == nil {return}
	if self.children == nil || len(self.children) == 0 {return}

	// Cycle through children and divy up the self.space
	global_offset: mc.Vec2 = element_recalculate_global_position(self)

	offset := mc.Vec2{0.0, 0.0}

	switch self.alignment {
	case .LEFT:
		{
			for c, _ in self.children {

				desired_size := mc.Vec2{c.rect.width, c.rect.height}
				desired_position := mc.Vec2{0.0, 0.0}

				determine_vertical_sizing(
					c,
					self,
					&desired_position,
					&desired_size,
				)

				desired_position.x += offset.x
				offset.x += c.min_size.x + self.padding

				c.rect = mc.Rect {
					desired_position.x + global_offset.x,
					desired_position.y + global_offset.y,
					desired_size.x,
					desired_size.y,
				}
				#partial switch v in c.variant {
				case ^Mallard_Vertical_Container:
					{
						mal_vertical_layout_calculate(v)
						continue
					}
				case ^Mallard_Horizontal_Container:
					{
						mal_horizontal_layout_calculate(v)
						continue
					}
				}

				element_interaction(c)
			}

		}
	case .CENTER:
		{
			space_used := element_calculate_used_space_horizontal(self)

			for c, _ in self.children {

				desired_size := mc.Vec2{c.rect.width, c.rect.height}
				desired_position := mc.Vec2 {
					self.rect.width / 2.0 - space_used / 2.0,
					0.0,
				}

				determine_vertical_sizing(
					c,
					self,
					&desired_position,
					&desired_size,
				)

				desired_position.x += offset.x
				offset.x += c.min_size.x + self.padding

				c.rect = mc.Rect {
					desired_position.x + global_offset.x,
					desired_position.y + global_offset.y,
					desired_size.x,
					desired_size.y,
				}

				#partial switch v in c.variant {
				case ^Mallard_Vertical_Container:
					{
						mal_vertical_layout_calculate(v)
						continue
					}
				case ^Mallard_Horizontal_Container:
					{
						mal_horizontal_layout_calculate(v)
						continue
					}
				}
				element_interaction(c)
			}
		}
	case .RIGHT:
		{
			#reverse for c, _ in self.children {

				desired_size := mc.Vec2{c.rect.width, c.rect.height}
				desired_position := mc.Vec2 {
					self.rect.width - desired_size.x,
					0.0,
				}

				determine_vertical_sizing(
					c,
					self,
					&desired_position,
					&desired_size,
				)

				desired_position.x += offset.x
				offset.x -= c.min_size.x + self.padding

				c.rect = mc.Rect {
					desired_position.x + global_offset.x,
					desired_position.y + global_offset.y,
					desired_size.x,
					desired_size.y,
				}
				#partial switch v in c.variant {
				case ^Mallard_Vertical_Container:
					{
						mal_vertical_layout_calculate(v)
						continue
					}
				case ^Mallard_Horizontal_Container:
					{
						mal_horizontal_layout_calculate(v)
						continue
					}
				}
				element_interaction(c)
			}
		}


	}

}

mal_layout_calculate :: proc(self: ^Mallard_Element) {
	if self == nil {return}
	if len(self.children) == 0 {
		log.info(
			"[Mallard][mal_layout_calculate] Calculating layout is redundent for a childless container",
		)
		return
	}

	for c in self.children {
		#partial switch v in c.variant {
		case ^Mallard_Vertical_Container:
			{
				mal_vertical_layout_calculate(v)
			}

		case ^Mallard_Horizontal_Container:
			{
				mal_horizontal_layout_calculate(v)
			}
		}
	}
}

determine_horizontal_sizing :: proc(
	self: ^Mallard_Element,
	container: ^Mallard_Element,
	dp: ^mc.Vec2,
	ds: ^mc.Vec2,
) {
	if self == nil {return}
	// Keep in mind that this is a vertical layout, so the space to divy
	// is the vertical spacing. Elements can fill up the horizontal 
	// space if they desire to
	switch self.horizontal_sizing {
	case .FILL:
		{
			ds.x = container.rect.width
			self.min_size.x = ds.x
		}
	case .CENTER:
		{
			dp.x = container.rect.width / 2.0 - ds.x / 2.0
		}
	case .END:
		{
			dp.x = container.rect.width - ds.x
		}
	case .BEGIN:
		fallthrough
	}
}

determine_vertical_sizing :: proc(
	self: ^Mallard_Element,
	container: ^Mallard_Element,
	dp: ^mc.Vec2,
	ds: ^mc.Vec2,
) {
	if self == nil {return}
	// Keep in mind that this is a horizontal layout, so the space to divy
	// is the horizontal spacing. Elements can fill up the vertical 
	// space if they desire to
	switch self.vertical_sizing {
	case .FILL:
		{
			ds.y = container.rect.height
			self.min_size.y = ds.y
		}
	case .CENTER:
		{
			dp.y = container.rect.height / 2.0 - ds.y / 2.0
		}
	case .END:
		{
			dp.y = container.rect.height - ds.y
		}
	case .BEGIN:
		fallthrough
	}
}

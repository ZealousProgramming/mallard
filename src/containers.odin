package mallard

import q "core:container/queue"
import "core:log"

import mc "./common"

container_draw :: proc(self: ^Mallard_Element) {
	gp := element_recalculate_global_position(self)
	mc._drawRectLinesEx(
		mc.Rect{gp.x, gp.y, self.rect.width, self.rect.height},
		2.0,
		DEBUG_BOUNDING_BOX_COLOR,
	)
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
	//b.rect.x += state.stack_position.x
	//b.rect.y += state.stack_position.y
	b.space.x = rect.width
	b.space.y = rect.height

	b.padding = 5.0

	if q.len(container_stack) > 0 {
		container := q.peek_back(&container_stack)^
		append(&container.children, b)
		b.container = container

		#partial switch v in container.variant {
		case ^Mallard_Vertical_Container, ^Mallard_Horizontal_Container:
			{
				b.sublayout = true
			}
		}

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

	if q.len(container_stack) > 0 {
		container := q.peek_back(&container_stack)^
		append(&container.children, b)
		b.container = container

		#partial switch v in container.variant {
		case ^Mallard_Vertical_Container, ^Mallard_Horizontal_Container:
			{
				b.sublayout = true
			}
		}
	}

	b.variant = b
	b.alignment = alignment
	b.padding = 5.0
	mal_adjust_size(b, mc.Vec2{rect.width, rect.height})

	// Render Command
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
	for c in self.children {
		mal_container_size_check(self, mc.Vec2{c.rect.width, c.rect.height})
	}

	// Cycle through children and divy up the self.space

	offset := mc.Vec2{0.0, 0.0}
	space_used := element_calculate_used_space_vertical(self)
	mal_container_size_check(self, mc.Vec2{self.rect.width, space_used})

	switch self.alignment {
	case .TOP:
		{
			for c, _ in self.children {

				desired_size := mc.Vec2{c.rect.width, c.rect.height}
				desired_position := mc.Vec2{0.0, 0.0}

				#partial switch v in c.variant {
				case ^Mallard_Vertical_Container:
					{
						desired_size.y = element_calculate_used_space_vertical(
							v,
						)
					}
				case ^Mallard_Horizontal_Container:
					{
						desired_size.y = element_calculate_used_space_vertical(
							v,
						)
					}
				}

				determine_horizontal_sizing(
					c,
					self,
					&desired_position,
					&desired_size,
				)

				desired_position.y += offset.y
				offset.y += desired_size.y + self.padding

				c.rect = mc.Rect {
					desired_position.x,
					desired_position.y,
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

			for c, _ in self.children {
				desired_size := mc.Vec2{c.rect.width, c.rect.height}
				desired_position := mc.Vec2 {
					0.0,
					self.rect.height / 2.0 - space_used / 2.0,
				}

				#partial switch v in c.variant {
				case ^Mallard_Vertical_Container:
					{
						for lc in v.children {
							mal_container_size_check(
								v,
								mc.Vec2{0.0, lc.rect.height},
							)
						}

						desired_size.y = element_calculate_used_space_vertical(
							v,
						)

					}


				case ^Mallard_Horizontal_Container:
					{
						for lc in v.children {
							mal_container_size_check(
								v,
								mc.Vec2{0.0, lc.rect.height},
							)
						}

						desired_size.y = element_calculate_used_space_vertical(
							v,
						)
					}

				}

				determine_horizontal_sizing(
					c,
					self,
					&desired_position,
					&desired_size,
				)
				mc._drawCircleV(desired_position, 5, mc.YELLOW)

				desired_position.y += offset.y
				offset.y += desired_size.y + self.padding

				c.rect = mc.Rect {
					desired_position.x,
					desired_position.y,
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
	case .BOTTOM:
		{
			#reverse for c, _ in self.children {

				desired_size := mc.Vec2{c.rect.width, c.rect.height}
				#partial switch v in c.variant {
				case ^Mallard_Vertical_Container:
					{
						for lc in v.children {
							mal_container_size_check(
								v,
								mc.Vec2{0.0, lc.rect.height},
							)
						}

						desired_size.y = element_calculate_used_space_vertical(
							v,
						)

					}


				case ^Mallard_Horizontal_Container:
					{
						for lc in v.children {
							mal_container_size_check(
								v,
								mc.Vec2{0.0, lc.rect.height},
							)
						}

						desired_size.y = element_calculate_used_space_vertical(
							v,
						)
					}

				}
				// NOTE(devon): We're change the desired_size of sublayouts above, so this needs to be after unlike 
				// on the other alignments
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
				offset.y -= desired_size.y + self.padding

				c.rect = mc.Rect {
					desired_position.x,
					desired_position.y,
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

mal_horizontal_layout_calculate :: proc(self: ^Mallard_Horizontal_Container) {
	if self == nil {return}
	if self.children == nil || len(self.children) == 0 {return}

	// Cycle through children and divy up the self.space
	global_offset: mc.Vec2 = element_recalculate_global_position(self)

	// Find out the container's size
	for c in self.children {
		mal_container_size_check(self, mc.Vec2{c.rect.width, c.rect.height})
	}

	offset := mc.Vec2{0.0, 0.0}
	space_used := element_calculate_used_space_horizontal(self)
	mal_container_size_check(self, mc.Vec2{space_used, self.rect.height})


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
				offset.x += desired_size.x + self.padding

				c.rect = mc.Rect {
					desired_position.x, // + global_offset.x,
					desired_position.y, // + global_offset.y,
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
				offset.x += desired_size.x + self.padding

				c.rect = mc.Rect {
					desired_position.x, //+ global_offset.x,
					desired_position.y, //+ global_offset.y,
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
				offset.x -= desired_size.x + self.padding

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

mal_adjust_size :: proc(self: ^Mallard_Element, new_size: mc.Vec2) {
	self.rect.width = new_size.x
	self.rect.height = new_size.y

	#partial switch v in self.variant {
	case ^Mallard_Vertical_Container:
		{
			v.space = new_size
		}
	case ^Mallard_Horizontal_Container:
		{
			v.space = new_size
		}
	}
}

package mallard
import mc "./common"
import c "core:c"
import "core:mem"

Mallard_State :: struct {
	viewport_bg_color, component_bg_color:                   mc.Color,
	screen_width, screen_height:                             c.int,
	viewport_x, viewport_y, viewport_width, viewport_height: c.int,
	mouse_position:                                          mc.Vec2,
	stack_position:                                          mc.Vec2,
}

Mallard_Render_Command :: struct {
	draw:     #type proc(el: ^Mallard_Element),
	deinit:   #type proc(el: ^Mallard_Element, allocator: mem.Allocator),
	instance: ^Mallard_Element,
}

Mallard_Ui_Error :: enum {
	NIL,
	TYPE_NOT_FOUND,
}

Mallard_Sizing_Behavior :: enum {
	FILL, // Fills the available space without affecting other elements
	BEGIN, // Align with container start, and only fill the minimum size of the element
	CENTER, // Align with container center, and only fill the minimum size of the element
	END, // Align with container end, and only fill the minimum size of the element
}

Mallard_Button_State :: enum {
	NORMAL,
	HOVER,
	SELECTED,
}

Mallard_TextField_State :: enum {
	NORMAL,
	HOVER,
	FOCUSED,
}

Mallard_Horizontal_Alignment :: enum {
	CENTER,
	LEFT,
	RIGHT,
}

Mallard_Vertical_Alignment :: enum {
	CENTER,
	TOP,
	BOTTOM,
}

Mallard_Element :: struct {
	rect:      mc.Rect,
	min_size:  mc.Vec2,
	vertical_sizing: Mallard_Sizing_Behavior,
	horizontal_sizing: Mallard_Sizing_Behavior,
	// Weak
	container: ^Mallard_Element,
	children:  [dynamic]^Mallard_Element,
	variant:   union {
		^Mallard_Window,
		^Mallard_ScrollBox,
		^Mallard_Scrollbar,
		^Mallard_ScrollBox_Contents,
		^Mallard_Button,
		^Mallard_Label,
		^Mallard_Divider,
		^Mallard_TextField,
		^Mallard_Viewport,
		^Mallard_Panel,
		^Mallard_Container,
		^Mallard_Vertical_Container,
	},
}

Mallard_Button :: struct {
	using uie: Mallard_Element,
	// label:     ^Mallard_Label,
	text:      cstring,
	state:     Mallard_Button_State,
	style:     Mallard_Button_Style,
	draggable: bool,
	dragging:  bool,
	on_click:  #type proc(),
}

Mallard_Label :: struct {
	using uie:        Mallard_Element,
	text:             cstring,
	foreground_color: mc.Color,
	valign:           Mallard_Vertical_Alignment,
	halign:           Mallard_Horizontal_Alignment,
	hpadding:         f32,
	allocated:        bool,
}

Mallard_TextField :: struct {
	using uie:        Mallard_Element,
	state:            Mallard_TextField_State,
	background_color: mc.Color,
	caret_offset:     f32,
	hpadding:         f32,
	has_focus:        bool,
}

Mallard_Divider :: struct {
	using uie: Mallard_Element,
}

Mallard_ScrollBox :: struct {
	using uie:      Mallard_Element,
	selected_index: int,
	contents:       ^Mallard_ScrollBox_Contents,
}

Mallard_ScrollBox_Contents :: struct {
	using uie: Mallard_Element,
}

Mallard_Scrollbar :: struct {
	using uie: Mallard_Element,
}

Mallard_Window :: struct {
	using uie:        Mallard_Element,
	background_color: mc.Color,
	hide:             bool,
	encompassing:     bool,
	hide_window:      #type proc(),
}

Mallard_Viewport :: struct {
	using uie:   Mallard_Element,
	clear_color: mc.Color,
	texture:     mc.RenderTexture,
}

Mallard_Panel :: struct {
	using uie:        Mallard_Element,
	background_color: mc.Color,
}

Mallard_Container :: struct {
	using uie: Mallard_Element,
}

Mallard_Vertical_Container :: struct {
	using uie: Mallard_Element,
	alignment: Mallard_Vertical_Alignment,
	fill:      bool,
}

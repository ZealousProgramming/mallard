package mallard
import mc "./common"
import "core:mem"

Mallard_Ui_Error :: enum {
	NIL,
	TYPE_NOT_FOUND,
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

Mallard_Transform :: struct {
	global: mc.Vec2,
	local:  mc.Vec2,
	size:   mc.Vec2,
}

Mallard_Element_VTable :: struct {
	handle_input: #type proc(el: ^Mallard_Element, evt: Input_Event) -> bool,
	draw:         #type proc(el: ^Mallard_Element),
	update:       #type proc(el: ^Mallard_Element),
	init:         #type proc(el: ^Mallard_Element, allocator: mem.Allocator),
	deinit:       #type proc(el: ^Mallard_Element, allocator: mem.Allocator),
}

Mallard_Element :: struct {
	using vtable: ^Mallard_Element_VTable,
	transform:    Mallard_Transform,
	// Weak
	container:    ^Mallard_Transform,
	children:     [dynamic]^Mallard_Element,
	variant:      union {
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
	},
}

Mallard_Button :: struct {
	using uie:      Mallard_Element,
	label:          ^Mallard_Label,
	state:          Mallard_Button_State,
	hover_color:    mc.Color,
	normal_color:   mc.Color,
	selected_color: mc.Color,
	draggable:      bool,
	dragging:       bool,
	is_rounded:     bool,
	segments:       int,
	roundness:      f32,
	line_thickness: f32,
	on_click:       #type proc(),
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

package mallard

import mc "./common"
// import la "core:math/linalg"

MOUSE_WHEEL_SPEED: f32 = 7.0

@(private = "file")
key_options := []mc.KeyboardKey {
	mc.KeyboardKey.A,
	mc.KeyboardKey.B,
	mc.KeyboardKey.C,
	mc.KeyboardKey.D,
	mc.KeyboardKey.E,
	mc.KeyboardKey.F,
	mc.KeyboardKey.G,
	mc.KeyboardKey.H,
	mc.KeyboardKey.I,
	mc.KeyboardKey.J,
	mc.KeyboardKey.K,
	mc.KeyboardKey.L,
	mc.KeyboardKey.M,
	mc.KeyboardKey.N,
	mc.KeyboardKey.O,
	mc.KeyboardKey.P,
	mc.KeyboardKey.Q,
	mc.KeyboardKey.R,
	mc.KeyboardKey.S,
	mc.KeyboardKey.T,
	mc.KeyboardKey.U,
	mc.KeyboardKey.V,
	mc.KeyboardKey.W,
	mc.KeyboardKey.X,
	mc.KeyboardKey.Y,
	mc.KeyboardKey.Z,
	mc.KeyboardKey.ZERO,
	mc.KeyboardKey.ONE,
	mc.KeyboardKey.TWO,
	mc.KeyboardKey.THREE,
	mc.KeyboardKey.FOUR,
	mc.KeyboardKey.FIVE,
	mc.KeyboardKey.SIX,
	mc.KeyboardKey.SEVEN,
	mc.KeyboardKey.EIGHT,
	mc.KeyboardKey.NINE,
	mc.KeyboardKey.SPACE,
	mc.KeyboardKey.MINUS,
	mc.KeyboardKey.TAB,
	mc.KeyboardKey.PAGE_UP,
	mc.KeyboardKey.PAGE_DOWN,
	mc.KeyboardKey.HOME,
	mc.KeyboardKey.DELETE,
	mc.KeyboardKey.UP,
	mc.KeyboardKey.DOWN,
	mc.KeyboardKey.LEFT,
	mc.KeyboardKey.RIGHT,
	mc.KeyboardKey.BACKSPACE,
	mc.KeyboardKey.ESCAPE,
	mc.KeyboardKey.PERIOD,
	mc.KeyboardKey.COMMA,
	mc.KeyboardKey.EQUAL,
	mc.KeyboardKey.ENTER,
	mc.KeyboardKey.GRAVE,
}

Input_Event_Kind :: enum {
	NIL,
	KEYBOARD,
	MOUSE_MOVE,
	MOUSE_DRAG,
	MOUSE_WHEEL,
	MOUSE_BUTTON,
	MOUSE_MOTION,
}

Keyboard_Event_Kind :: enum {
	NIL,
	PRESSED,
	DOWN,
	RELEASED,
}

Mouse_Button_Event_Kind :: enum {
	NIL,
	LEFT,
	MIDDLE,
	RIGHT,
}

Mouse_Button_Action_Event_Kind :: enum {
	NIL,
	PRESSED,
	DOWN,
	RELEASED,
}

Input_Event :: struct {
	input_kind: Input_Event_Kind,
	variant:    union {
		^Keyboard_Event,
		^Mouse_Button_Event,
		^Mouse_Wheel_Event,
		^Mouse_Motion_Event,
	},
}

Keyboard_Event :: struct {
	using input_event: Input_Event,
	kb_kind:           Keyboard_Event_Kind,
	key:               mc.KeyboardKey,
	value:             rune,
}

Mouse_Button_Event :: struct {
	using input_event: Input_Event,
	mb_kind:           Mouse_Button_Event_Kind,
	action_kind:       Mouse_Button_Action_Event_Kind,
	mouse_position:    mc.Vec2,
}

Mouse_Motion_Event :: struct {
	using input_event: Input_Event,
	mouse_position:    mc.Vec2,
}

Mouse_Wheel_Event :: struct {
	using input_event: Input_Event,
	mouse_position:    mc.Vec2,
	delta:             f32,
}

CLICK_OFFSET: mc.Vec2

@(private = "file")
previous_mouse_position: mc.Vec2

editor_input_event_unwrap :: proc(c: ^Input_Event, $T: typeid) -> (^T, Maybe(Mallard_Ui_Error)) {
	#partial switch c in c.variant {
	case ^T:
		{
			return c, nil
		}
	}

	return nil, .TYPE_NOT_FOUND
}

editor_input :: proc(dt: f32) {
	editor_mouse_motion_check()
	editor_mouse_button_check()
	editor_mouse_wheel_check()
	editor_keyboard_check()

	previous_mouse_position = get_mouse_position()
}

editor_handle_input :: proc(el: ^Mallard_Element, evt: Input_Event) -> bool {
	for e in el.children {
		editor_handle_input(e, evt)
	}

	if el.handle_input != nil {
		if el.handle_input(el, evt) {return true}
	}


	return false
}

editor_mouse_motion_check :: proc() {
	if get_mouse_position() == previous_mouse_position {
		return
	}

	mme := Mouse_Motion_Event{}

	mme.variant = &mme
	mme.input_kind = .MOUSE_MOTION
	mme.mouse_position = get_mouse_position()

	for el in root_elements {
		if editor_handle_input(el, mme) {break}
	}
}

editor_mouse_button_check :: proc() {
	mbe := Mouse_Button_Event {
		mb_kind = .NIL,
	}
	mbe.variant = &mbe

	if is_mouse_button_pressed(mc.MouseButton.LEFT) {
		mbe.input_kind = .MOUSE_BUTTON
		mbe.mb_kind = .LEFT
		mbe.action_kind = .PRESSED
		mbe.mouse_position = get_mouse_position()
	} else if is_mouse_button_down(mc.MouseButton.LEFT) {
		mbe.input_kind = .MOUSE_BUTTON
		mbe.mb_kind = .LEFT
		mbe.action_kind = .DOWN
		mbe.mouse_position = get_mouse_position()
	} else if is_mouse_button_released(mc.MouseButton.LEFT) {
		mbe.input_kind = .MOUSE_BUTTON
		mbe.mb_kind = .LEFT
		mbe.action_kind = .RELEASED
		mbe.mouse_position = get_mouse_position()
	} else if is_mouse_button_released(mc.MouseButton.RIGHT) {
		mbe.input_kind = .MOUSE_BUTTON
		mbe.mb_kind = .RIGHT
		mbe.action_kind = .RELEASED
		mbe.mouse_position = get_mouse_position()
	}

	if mbe.mb_kind == .NIL {return}

	for el in root_elements {
		if editor_handle_input(el, mbe) {break}
	}
}

editor_mouse_wheel_check :: proc() {
	mwe := Mouse_Wheel_Event {
		input_kind = .NIL,
	}
	mwe.variant = &mwe

	delta: f32 = get_mouse_wheel_move()

	if delta != 0.0 {
		mwe.input_kind = .MOUSE_WHEEL
		mwe.delta = delta
		mwe.mouse_position = get_mouse_position()
	}


	if mwe.input_kind == .NIL {return}

	for el in root_elements {
		if editor_handle_input(el, mwe) {break}
	}
}

editor_keyboard_check :: proc() {
	evt := new(Keyboard_Event, context.temp_allocator)

	evt.input_kind = .KEYBOARD
	evt.kb_kind = .NIL
	evt.variant = evt

	for key in key_options {
		editor_key_check(evt, key)

		if evt.kb_kind == .NIL {continue}

		for el in root_elements {
			if editor_handle_input(el, evt) {break}
		}
	}

	free(evt, context.temp_allocator)
}

editor_key_check :: proc(evt: ^Keyboard_Event, k: mc.KeyboardKey) {
	evt.key = k

	if is_key_pressed(k) {
		evt.kb_kind = .PRESSED
		evt.value = get_char_pressed()

		return
	}

	if is_key_released(k) {
		evt.kb_kind = .RELEASED

		return
	}

	if is_key_down(k) {
		evt.kb_kind = .DOWN
		evt.value = get_char_pressed()

		return
	}

	evt.kb_kind = .NIL
}

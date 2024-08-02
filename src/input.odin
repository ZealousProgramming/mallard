package mallard
import mc "./common"

get_axis_keyboard :: proc(axis: mc.InputAxis) -> f32 {
	#partial switch axis {
	case .LEFT_X:
		{
			l: f32 = is_key_down(mc.KeyboardKey.A) ? 1.0 : 0.0
			r: f32 = is_key_down(mc.KeyboardKey.D) ? 1.0 : 0.0

			return r - l
		}

	case .LEFT_Y:
		{
			d: f32 = is_key_down(mc.KeyboardKey.W) ? 1.0 : 0.0
			u: f32 = is_key_down(mc.KeyboardKey.S) ? 1.0 : 0.0

			return u - d
		}

	case:
		return 0.0

	}

}

// Input-related functions: keyboard
// @(export)
is_key_pressed :: proc(key: mc.KeyboardKey) -> bool {
	return mc._isKeyPressed(key)
}

// @(export)
is_key_down :: proc(key: mc.KeyboardKey) -> bool {
	return mc._isKeyDown(key)
}

// @(export)
is_key_released :: proc(key: mc.KeyboardKey) -> bool {
	return mc._isKeyReleased(key)
}

// @(export)
is_key_up :: proc(key: mc.KeyboardKey) -> bool {
	return mc._isKeyUp(key)
}

// @(export)
set_exit_key :: proc(key: mc.KeyboardKey) {
	mc._setExitKey(key)
}

// @(export)
get_key_pressed :: proc() -> mc.KeyboardKey {
	return mc._getKeyPressed()
}

// @(export)
get_char_pressed :: proc() -> rune {
	return mc._getCharPressed()
}

// Input-related functions: gamepads
// @(export)
is_gamepad_available :: proc(gamepad: i32) -> bool {
	return mc._isGamepadAvailable(gamepad)
}

// @(export)
get_gamepad_name :: proc(gamepad: i32) -> string {
	return string(mc._getGamepadName(gamepad))
}

// @(export)
is_gamepad_button_pressed :: proc(gamepad: i32, button: mc.GamepadButton) -> bool {
	return mc._isGamepadButtonPressed(gamepad, button)
}

// @(export)
is_gamepad_button_down :: proc(gamepad: i32, button: mc.GamepadButton) -> bool {
	return mc._isGamepadButtonDown(gamepad, button)
}

// @(export)
is_gamepad_button_released :: proc(gamepad: i32, button: mc.GamepadButton) -> bool {
	return mc._isGamepadButtonReleased(gamepad, button)
}

// @(export)
is_gamepad_button_up :: proc(gamepad: i32, button: mc.GamepadButton) -> bool {
	return mc._isGamepadButtonUp(gamepad, button)
}

// @(export)
get_gamepad_button_pressed :: proc() -> mc.GamepadButton {
	return mc._getGamepadButtonPressed()
}

// @(export)
get_gamepad_axis_count :: proc(gamepad: i32) -> i32 {
	return mc._getGamepadAxisCount(gamepad)
}

// @(export)
get_gamepad_axis_movement :: proc(gamepad: i32, axis: mc.GamepadAxis) -> f32 {
	return mc._getGamepadAxisMovement(gamepad, axis)
}

// @(export)
set_gamepad_mappings :: proc(mappings: cstring) -> i32 {
	return mc._setGamepadMappings(mappings)
}

// Input-related functions: mouse
// @(export)
is_mouse_button_pressed :: proc(button: mc.MouseButton) -> bool {
	return mc._isMouseButtonPressed(button)
}

// @(export)
is_mouse_button_down :: proc(button: mc.MouseButton) -> bool {
	return mc._isMouseButtonDown(button)
}

// @(export)
is_mouse_button_released :: proc(button: mc.MouseButton) -> bool {
	return mc._isMouseButtonReleased(button)
}

// @(export)
is_mouse_button_up :: proc(button: mc.MouseButton) -> bool {
	return mc._isMouseButtonUp(button)
}

// @(export)
get_mouse_x :: proc() -> i32 {
	return mc._getMouseX()
}

// @(export)
get_mouse_y :: proc() -> i32 {
	return mc._getMouseY()
}

// @(export)
get_mouse_position :: proc() -> mc.Vec2 {
	return mc._getMousePosition()
}

// @(export)
get_mouse_delta :: proc() -> mc.Vec2 {
	return mc._getMouseDelta()
}

// @(export)
set_mouse_position :: proc(x: i32, y: i32) {
	mc._setMousePosition(x, y)
}

// @(export)
set_mouse_offset :: proc(ox: i32, oy: i32) {
	mc._setMouseOffset(ox, oy)
}

// @(export)
set_mouse_scale :: proc(sx: f32, sy: f32) {
	mc._setMouseScale(sx, sy)
}

// @(export)
get_mouse_wheel_move :: proc() -> f32 {
	return mc._getMouseWheelMove()
}

// @(export)
get_mouse_wheel_move_vec :: proc() -> mc.Vec2 {
	return mc._getMouseWheelMoveV()
}

// @(export)
set_mouse_cursor :: proc(cursor: mc.MouseCursor) {
	mc._setMouseCursor(cursor)
}

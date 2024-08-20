package mallard

import mc "./common"
import rl "vendor:raylib"

Mallard_Theme :: struct {
	accent:       mc.Color,
	light:        mc.Color,
	medium:       mc.Color,
	dark:         mc.Color,
	night:        mc.Color,
	text:         mc.Color,
	inverse_text: mc.Color,
}

Mallard_Button_Style :: struct {
	normal_color:   rl.Color,
	hover_color:    rl.Color,
	pressed_color:  mc.Color,
	text_color:     mc.Color,
	padding:        mc.Vec2,
	segments:       int,
	roundness:      f32,
	line_thickness: f32,
	is_rounded:     bool,
}

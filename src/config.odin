package mallard

import mc "./common"

EDITOR_FONT_SIZE := 18
EDITOR_FONT_SPACING: f32 = 1.0

DRAW_DEBUG_BOX :: false
DRAW_ONLY_LAYOUTS :: false
DEBUG_BOUNDING_BOX_COLOR := mc.Color{255, 0.0, 0.0, 140}

editor_font: mc.Font

// -- Themes --
DEFAULT_THEME :: Mallard_Theme {
	accent       = mc.Color{114, 137, 218, 255},
	light        = mc.Color{120, 120, 120, 255},
	medium       = mc.Color{96, 96, 96, 255},
	dark         = mc.Color{48, 48, 48, 255},
	night        = mc.Color{24, 24, 24, 255},
	text         = mc.Color{235, 235, 235, 255},
	inverse_text = mc.Color{64, 64, 64, 255},
}

// -- DEFAULTS --
DEFAULT_BUTTON_STYLE := Mallard_Button_Style {
	normal_color   = DEFAULT_THEME.accent,
	hover_color    = DEFAULT_THEME.light,
	pressed_color  = DEFAULT_THEME.night,
	text_color     = DEFAULT_THEME.text,
	padding        = mc.Vec2{8, 2},
	segments       = 12,
	roundness      = 0.2,
	line_thickness = 4.0,
	is_rounded     = true,
}

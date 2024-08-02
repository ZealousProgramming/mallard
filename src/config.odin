package mallard

import mc "./common"

EDITOR_FONT_SIZE := 18
EDITOR_FONT_SPACING: f32 = 1.0

DEBUG_BOUNDING_BOX_COLOR := mc.Color{255, 0.0, 0.0, 140}

editor_font: mc.Font

// -- DEFAULTS --
DEFAULT_BUTTON_STYLE :: Mallard_Button_Style {
	normal_color = mc.Color{96, 96, 96, 255},
	hover_color = mc.Color{120, 120, 120, 255},
	segments = 12,
	roundness = 0.2,
	line_thickness = 4.0,
	is_rounded = true,
}

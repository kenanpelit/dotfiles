local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Performance & GPU Settings
config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"
config.max_fps = 120
config.animation_fps = 60
config.enable_wayland = true
config.enable_kitty_keyboard = false
config.warn_about_missing_glyphs = false
config.enable_kitty_graphics = false
config.enable_csi_u_key_encoding = false
config.check_for_updates = false

-- Font Configuration
config.font = wezterm.font_with_fallback({
	{ family = "Hack Nerd Font", weight = "Regular" },
})
config.font_size = 13.3
config.line_height = 1.0
config.harfbuzz_features = { "liga", "calt" }

-- Window Appearance
config.window_padding = {
	left = 8,
	right = 8,
	top = 8,
	bottom = 8,
}
config.window_decorations = "NONE"
config.window_background_opacity = 1.0

-- Tab Bar
config.enable_tab_bar = true
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = false
config.tab_max_width = 25

-- Cursor & Mouse
config.default_cursor_style = "SteadyBlock"
config.cursor_blink_rate = 500
config.force_reverse_video_cursor = true
config.cursor_thickness = 1.5
config.scrollback_lines = 10000
config.enable_scroll_bar = false
config.hide_mouse_cursor_when_typing = true

-- Mouse Bindings
config.mouse_bindings = {
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "NONE",
		action = wezterm.action.CompleteSelection("ClipboardAndPrimarySelection"),
	},
}

-- Colors
config.colors = {
	foreground = "#d8dae9",
	background = "#24283B",
	cursor_bg = "#d6acff",
	cursor_fg = "#6272a4",
	selection_fg = "#282a36",
	selection_bg = "#bd93f9",
	tab_bar = {
		background = "#1e1f29",
		active_tab = {
			bg_color = "#bd93f9",
			fg_color = "#282a36",
		},
		inactive_tab = {
			bg_color = "#282a36",
			fg_color = "#f8f8f2",
		},
	},
	ansi = {
		"#595D71",
		"#f38ba8",
		"#50fa7b",
		"#f1fa8c",
		"#bd93f9",
		"#ff79c6",
		"#8be9fd",
		"#f8f8f2",
	},
	brights = {
		"#6272a4",
		"#e95678",
		"#69ff94",
		"#ffffa5",
		"#d6acff",
		"#ff92df",
		"#a4ffff",
		"#ffffff",
	},
}

wezterm.on("format-window-title", function(tab, pane, tabs, panes, config)
	local zoomed = tab.active_pane.is_zoomed and "[Z] " or ""
	local index = #tabs > 1 and string.format("[%d/%d] ", tab.tab_index + 1, #tabs) or ""
	return zoomed .. index .. tab.active_pane.title
end)

-- Environment Variables
config.set_environment_variables = {
	WINIT_UNIX_BACKEND = "wayland",
	WINIT_X11_SCALE_FACTOR = "1",
	GDK_SCALE = "1",
	QT_AUTO_SCREEN_SCALE_FACTOR = "0",
	LIBGL_DRI3_DISABLE = "1",
	WLR_NO_HARDWARE_CURSORS = "1",
	XCURSOR_SIZE = "24",
	MESA_GL_VERSION_OVERRIDE = "4.6",
	MESA_LOADER_DRIVER_OVERRIDE = "iris",
	LIBVA_DRIVER_NAME = "iHD",
	__GL_GSYNC_ALLOWED = "0",
	__GL_VRR_ALLOWED = "0",
}

return config

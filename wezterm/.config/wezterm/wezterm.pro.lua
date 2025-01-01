local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

-- Performance & GPU
config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"
config.max_fps = 120 -- Monitor yenileme hızına uygun
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
	{ family = "Hack Nerd Font Bold", weight = "Bold" },
	{ family = "Hack Nerd Font Italic", italic = true },
	{ family = "Hack Nerd Font Bold Italic", weight = "Bold", italic = true },
})
config.font_size = 13.3
config.line_height = 1.0
config.harfbuzz_features = {
	"kern", -- Karakter aralığı optimizasyonu
	"liga", -- Ligatures
	"clig", -- Contextual ligatures
	"calt", -- Contextual alternates
	"ss01", -- Stylistic set 1
}

-- Window Appearance
config.window_padding = { left = 6, right = 6, top = 6, bottom = 6 }
config.window_decorations = "NONE"
config.window_background_opacity = 1.0
config.text_background_opacity = 1.0
config.adjust_window_size_when_changing_font_size = false

-- Tab Bar
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.tab_max_width = 25
config.show_tab_index_in_tab_bar = false

-- Cursor & Terminal
config.default_cursor_style = "SteadyBlock"
config.cursor_blink_rate = 500
config.force_reverse_video_cursor = true
config.term = "wezterm"
config.scrollback_lines = 10000
config.enable_scroll_bar = false
config.hide_mouse_cursor_when_typing = true

-- URL Detection
config.hyperlink_rules = {
	-- Email adresleri
	{
		regex = [[\b\w+@[\w-]+(\.[\w-]+)+\b]],
		format = "mailto:$0",
	},
	-- URLs
	{
		regex = [[\b\w+://(?:[\w.-]+)\.[a-z]{2,15}\S*\b]],
		format = "$0",
	},
	-- File paths
	{
		regex = [[\b\.?/[^/\s]+(?:/[^/\s]+)*\b]],
		format = "file://$0",
	},
}

-- Mouse Bindings
config.mouse_bindings = {
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "NONE",
		action = act.CompleteSelection("ClipboardAndPrimarySelection"),
	},
	{
		event = { Up = { streak = 2, button = "Left" } },
		mods = "NONE",
		action = act.CompleteSelection("ClipboardAndPrimarySelection"),
	},
	{
		event = { Down = { streak = 3, button = "Left" } },
		mods = "NONE",
		action = act.SelectTextAtMouseCursor("Line"),
	},
	{
		event = { Down = { streak = 4, button = "Left" } },
		mods = "NONE",
		action = act.SelectTextAtMouseCursor("Block"), -- "All" yerine "Block" kullanıyoruz
	},
}

-- Performance Optimizations
config.allow_square_glyphs_to_overflow_width = "Never"
config.custom_block_glyphs = false
config.unicode_version = 14
config.freetype_load_target = "Light"

-- Color Scheme (Tokyonight)
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
		"#595D71", -- black
		"#f38ba8", -- red
		"#50fa7b", -- green
		"#f1fa8c", -- yellow
		"#bd93f9", -- blue
		"#ff79c6", -- magenta
		"#8be9fd", -- cyan
		"#f8f8f2", -- white
	},
	brights = {
		"#6272a4", -- bright black
		"#e95678", -- bright red
		"#69ff94", -- bright green
		"#ffffa5", -- bright yellow
		"#d6acff", -- bright blue
		"#ff92df", -- bright magenta
		"#a4ffff", -- bright cyan
		"#ffffff", -- bright white
	},
}

-- Wayland Environment Variables
config.set_environment_variables = {
	TERM = "wezterm",
	COLORTERM = "truecolor",
	WINIT_UNIX_BACKEND = "wayland",
	GDK_BACKEND = "wayland",
	QT_QPA_PLATFORM = "wayland",
	SDL_VIDEODRIVER = "wayland",
	CLUTTER_BACKEND = "wayland",
	XDG_CURRENT_DESKTOP = "sway",
	XDG_SESSION_TYPE = "wayland",
	MOZ_ENABLE_WAYLAND = "1",
	QT_AUTO_SCREEN_SCALE_FACTOR = "1",
	QT_WAYLAND_DISABLE_WINDOWDECORATION = "1",
}

wezterm.on("format-window-title", function(tab, pane, tabs, panes, config)
	local zoomed = tab.active_pane.is_zoomed and "[Z] " or ""
	local index = #tabs > 1 and string.format("[%d/%d] ", tab.tab_index + 1, #tabs) or ""
	return zoomed .. index .. tab.active_pane.title
end)

return config

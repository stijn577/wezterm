local wezterm = require "wezterm"
local config = wezterm.config_builder()

local action = wezterm.action

-- startup program
-- config.default_prog = { "C:/Users/stijn/AppData/Local/Programs/nu/bin/nu.exe" }
config.default_prog = { "nu.exe -l" }

-- theme and background settings
config.color_scheme = "Catppuccin Mocha"
config.colors = wezterm.color.get_builtin_schemes()[config.color_scheme]
config.adjust_window_size_when_changing_font_size = false

if config.color_scheme == "Catppuccin Mocha" then
  config.colors.selection_bg = "#89b4fa"
  config.colors.selection_fg = "#1e1e2e"
elseif config.color_scheme == "Catppuccin Macchiato" then
  config.colors.selection_bg = "#8aadf4"
  config.colors.selection_fg = "#24273a"
elseif config.color_scheme == "Catppuccin Latte" then
  config.colors.selection_bg = "#1e66f5"
  config.colors.selection_fg = "#eff1f5"
end
-- renderer
config.front_end = "OpenGL"
config.max_fps = 144
config.animation_fps = 144


-- window
-- config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.window_decorations = "NONE|RESIZE"
config.integrated_title_buttons = { }
config.window_padding = {
  left = 10,
  right = 2,
  top = 10,
  bottom = 0
}

-- config.win32_system_backdrop = 'Acrylic'


-- opacity
local opacity_local = 1.0
config.window_background_opacity = opacity_local

local increase_opacity = function(window, _)
  opacity_local = opacity_local + 0.05
  if opacity_local > 1.0 then
    opacity_local = 1.0
  end
  window:set_config_overrides({ window_background_opacity = opacity_local })
end

local decrease_opacity =  function(window, _)
  opacity_local = opacity_local - 0.05
  if opacity_local < 0.1 then
    opacity_local = 0.1
  end
  window:set_config_overrides({ window_background_opacity = opacity_local })
end

config.enable_scroll_bar = true

-- tab bar
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
-- config.hide_tab_bar_if_only_one_tab = true
config.tab_max_width = 1000

-- tab bar style scripting
wezterm.on("format-tab-title", function(tab, tabs, _, colors, _, _)
  wezterm.log_info("format tab title")
  local get_active_tab_index = function(tabs_pairs)
    for _, t in pairs(tabs_pairs) do
      if t.is_active then
        return t.tab_index
      end
    end
  end

  local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider
  local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider
  local SOLID_LEFT_ARROW_INVERSE = ""
  local SOLID_RIGHT_ARROW_INVERSE = ""

  local title = tab.active_pane.title
  local active_tab_index = get_active_tab_index(tabs)

  if tab.tab_title and #tab.tab_title > 0 then
    title = tab.tab_title
  end

  local first_tab = tab.tab_index == 0
  local last_tab = tab.tab_index == (#tabs - 1)

  if tab.tab_index < active_tab_index then
    return {
      { Background = { Color = config.colors.tab_bar.inactive_tab.bg_color } },
      { Foreground = { Color = config.colors.tab_bar.inactive_tab.fg_color } },
      { Text = first_tab and "" or SOLID_LEFT_ARROW .. SOLID_LEFT_ARROW_INVERSE },
      { Background = { Color = config.colors.tab_bar.inactive_tab.bg_color } },
      { Foreground = { Color = config.colors.tab_bar.inactive_tab.fg_color } },
      { Text = " " .. (tab.tab_index + 1) .. ": " .. title .. " " },
    }
  elseif tab.tab_index == active_tab_index then
    return {
      { Background = { Color = config.colors.tab_bar.active_tab.fg_color } },
      { Foreground = { Color = config.colors.tab_bar.active_tab.bg_color } },
      { Text = first_tab and "" or SOLID_LEFT_ARROW },
      { Background = { Color = config.colors.tab_bar.active_tab.bg_color } },
      { Foreground = { Color = config.colors.tab_bar.active_tab.fg_color } },
      { Text = " " .. (tab.tab_index + 1) .. ": " .. title .. " " },
      { Background = { Color = config.colors.tab_bar.active_tab.fg_color } },
      { Foreground = { Color = config.colors.tab_bar.active_tab.bg_color  } },
      { Text = last_tab and "" or SOLID_RIGHT_ARROW },
    }
  else
    return {
      { Background = { Color = config.colors.tab_bar.inactive_tab.bg_color } },
      { Foreground = { Color = config.colors.tab_bar.inactive_tab.fg_color } },
      { Text = " " .. (tab.tab_index + 1) .. ": " .. title .. " " },
      { Background = { Color = config.colors.tab_bar.inactive_tab.bg_coloreconfig.colors.tab_bar.inactive_tab.fg_color } },
      { Foreground = { Color =  config.colors.tab_bar.active_tab.fg_color    } },
      { Text = last_tab and "" or SOLID_RIGHT_ARROW_INVERSE .. SOLID_RIGHT_ARROW }
    }
  end
end)


config.font = wezterm.font(
  { family="Iosevka Nerd Font Propo", weight="Regular", stretch="Normal", style="Normal" }
)
config.font_size = 13

config.harfbuzz_features = { 
  -- "ss05=1",  -- Fira Mono style
  -- "ss07=1",  -- Moncao style
  -- "ss08=1",  -- Pragmata Pro style
  -- "ss12=1",  -- Ubuntu style 
  -- "ss14=1",  -- Jetbrains Mono style
  -- "ss15=1",  -- IBM Plex Mono style
  -- "ss17=1",  -- Recursive Mono style
}

-- keymaps
config.leader = { key = 'q', mods = 'ALT', timeout_milliseconds = 2000 }
config.keys = {
  -- disable ctrl + shift + t
  { key = 't', mods = 'SHIFT | CTRL', action = action.DisableDefaultAssignment },
  
  -- increase opacity
  { key = 'UpArrow', mods = 'LEADER', action = wezterm.action_callback(increase_opacity) },
  -- decrease opacity
  { key = 'DownArrow', mods = 'LEADER', action = wezterm.action_callback(decrease_opacity) },
  
  -- bind F11 to full screen
  { key = 'F11', action = action.ToggleFullScreen },
  -- bind ctrl + n to new tab
  { key = 't', mods = 'CTRL', action = action.SpawnTab 'DefaultDomain' },

  -- split view
  { key = '\'', mods = 'CTRL', action = action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = '\"', mods = 'CTRL | SHIFT', action = action.SplitVertical { domain = 'CurrentPaneDomain' } },

  -- navigate panes
  { key = 'l', mods = 'LEADER', action = action.ActivatePaneDirection 'Right' },
  { key = 'k', mods = 'LEADER', action = action.ActivatePaneDirection 'Up' },
  { key = 'j', mods = 'LEADER', action = action.ActivatePaneDirection 'Down' },
  { key = 'h', mods = 'LEADER', action = action.ActivatePaneDirection 'Left' },
  
  -- rotate panes
  { key = 'r', mods = 'LEADER', action = action.RotatePanes 'Clockwise' },
}


return config

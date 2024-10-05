local wezterm = require "wezterm"
local action = wezterm.action

local config = {}

-- startup program
config.default_prog = { "C:/Users/Stijn_Admin/AppData/Local/Programs/nu/bin/nu.exe" }

-- theme and background settings
config.window_decorations = "RESIZE"
config.use_fancy_tab_bar = false
config.tab_max_width = 50
config.color_scheme = "Catppuccin Macchiato"
local opacity = 1.0
config.window_background_opacity = opacity

local increase_opacity = function(window, pane)
  opacity = opacity + 0.05
  if opacity > 1.0 then
    opacity = 1.0
  end
  window:set_config_overrides({ window_background_opacity = opacity })
end

local decrease_opacity =  function(window, pane)
  opacity = opacity - 0.05
  if opacity < 0.1 then
    opacity = 0.1
  end
  window:set_config_overrides({ window_background_opacity = opacity })
end

-- font settings
config.font = wezterm.font(
  -- {"ZedMono Nerd Font Propo", { weight="Regular", stretch="Expanded", style="Normal" }},
  { family = "ZedMono NFP", weight="Regular", stretch="Expanded", style="Normal" }
  -- "ZedMono NFM",
  -- "ZedMono NF"
)
config.harfbuzz_features = { "CLIK=1" }
config.font_size = 12.25

config.keys = {
  -- disable ctrl + shift + t
  { key = 't', mods = 'SHIFT | CTRL', action = action.DisableDefaultAssignment },
  
  -- increase opacitiy
  { key = 'UpArrow', mods = 'SHIFT | CTRL', action = wezterm.action_callback(increase_opacity) },
  -- decrease opacity
  { key = 'DownArrow', mods = 'SHIFT | CTRL', action = wezterm.action_callback(decrease_opacity) },
  
  -- bind F11 to full screen
  { key = 'F11', action = action.ToggleFullScreen },
  -- bind ctrl + n to new tab
  { key = 'n', mods = 'CTRL', action = action.SpawnTab 'DefaultDomain' },
  -- navigate panes
  { key = 'LeftArrow', mods = 'ALT', action = action.ActivatePaneDirection ('Left')},
  { key = 'RightArrow', mods = 'ALT', action = action.ActivatePaneDirection ('Right')},
  { key = 'UpArrow', mods = 'ALT', action = action.ActivatePaneDirection ('Up')},
  { key = 'DownArrow', mods = 'ALT', action = action.ActivatePaneDirection ('Down')},
}

return config

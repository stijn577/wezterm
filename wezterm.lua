local wezterm = require "wezterm"
local action = wezterm.action

local config = {}

-- startup program
config.default_prog = { "C:/Users/Stijn_Admin/AppData/Local/Programs/nu/bin/nu.exe" }

-- theme and background settings
config.color_scheme = "Catppuccin Macchiato"

-- window
config.window_decorations = "RESIZE"

-- opacity
local opacity = 0.85
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

-- tab bar
config.use_fancy_tab_bar = false
-- config.tab_bar_at_bottom = true
config.tab_max_width = 50

-- font settings
config.font = wezterm.font(
  -- {"ZedMono Nerd Font Propo", { weight="Regular", stretch="Expanded", style="Normal" }},
  { family = "ZedMono NFP", weight="Regular", stretch="Expanded", style="Normal" }
  -- "ZedMono NFM",
  -- "ZedMono NF"
)
config.harfbuzz_features = { "CLIK=1" }
config.font_size = 12.25

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
  { key = 'h', mods = 'LEADER', action = action.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'LEADER', action = action.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'LEADER', action = action.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'LEADER', action = action.ActivatePaneDirection 'Right' },

  { key = 'r', mods = 'LEADER', action = action.RotatePanes 'Clockwise' },
}

return config

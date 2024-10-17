local wezterm = require "wezterm"
local action = wezterm.action

local config = wezterm.config_builder()

-- startup program
config.default_prog = { "C:/Users/Stijn_Admin/AppData/Local/Programs/nu/bin/nu.exe -l" }


-- theme and background settings
function scheme_for_appearance(appearance)
  if appearance:find "Dark" then
    return "Catppuccin Macchiato"
  else
    return "Catppuccin Latte"
  end
end

function change_scheme_appearance(appearance)
  if appearance:find "Dark" then
    appearance:set "Light"
  else
    appearance:set "Dark"
  end
end


config.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance())

-- renderer
config.front_end = "OpenGL"


-- window
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"


-- opacity
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


-- tab bar
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false 
config.hide_tab_bar_if_only_one_tab = true
config.tab_max_width = 1000

-- tab bar style scripting
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local get_active_tab_index = function(tabs)
    for _, t in pairs(tabs) do
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
      { Background = { Color = "#24273a" } },
      { Foreground = { Color = "#c6a0f6" } },
      { Text = first_tab and "" or SOLID_LEFT_ARROW .. SOLID_LEFT_ARROW_INVERSE },
      { Background = { Color = "#313244" } },
      { Foreground = { Color = "#a6adc8" } },
      { Text = " " .. (tab.tab_index + 1) .. ": " .. title .. " " },
    }
  elseif tab.tab_index == active_tab_index then
    return {
      { Background = { Color = "#313244" } },
      { Foreground = { Color = "#c6a0f6" } },
      { Text = first_tab and "" or SOLID_LEFT_ARROW },
      { Background = { Color = "#c6a0f6" } },
      { Foreground = { Color = "#313244" } },
      { Text = " " .. (tab.tab_index + 1) .. ": " .. title .. " " },
      { Background = { Color = "#313244" } },
      { Foreground = { Color = "#c6a0f6" } },
      { Text = last_tab and "" or SOLID_RIGHT_ARROW },
    }
  else
    return {
      { Background = { Color = "#24273a" } },
      { Foreground = { Color = "#6c7086" } },
      { Text = " " .. (tab.tab_index + 1) .. ": " .. title .. " " },
      { Background = { Color = "#24273a" } },
      { Foreground = { Color = "#c6a0f6" } },
      { Text = last_tab and "" or SOLID_RIGHT_ARROW_INVERSE .. SOLID_RIGHT_ARROW },
    }
  end
end)


-- font settings
config.font = wezterm.font(
  -- {"ZedMono Nerd Font Propo", { weight="Regular", stretch="Expanded", style="Normal" }},
  { family = "ZedMono NFP", weight="Medium", stretch="Expanded", style="Normal" }
  -- { family = "Hasklug Nerd Font Propo", weight = "Medium", stretch = "Expanded", style="Normal"}
  -- { family = "JetBrainsMono NFP", weight = "Regular", stretch = "Expanded", style = "Normal" }
  -- "ZedMono NFM", 
  -- "ZedMono NF"
)
config.harfbuzz_features = { 
  -- "ss08=1",  -- pragmata prop style
  -- "ss12=1",  -- ubuntu style 
}
-- config.font_size = 12.25
config.font_size = 12.25


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

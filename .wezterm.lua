-- Pull in the wezterm API
local wezterm = require 'wezterm'

local mux = wezterm.mux


-- This will hold the configuration.
local config = wezterm.config_builder()


-- start the terminal maximized
wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)
-- This is where you actually apply your config choices.

-- For example, changing the initial geometry for new windows:
config.initial_cols = 120
config.initial_rows = 28

-- or, changing the font size and color scheme.
config.font_size = 11

-- config.font = wezterm.font( 'Fira Code')
-- You can specify some parameters to influence the font selection;
-- for example, this selects a Bold, Italic font variant.
config.font = wezterm.font("Lucida Console", { weight = 'Bold'})


-- config.color_scheme = "carbonfox" 
-- config.color_scheme = 'Batman'
-- config.color_scheme = 'Catch Me If You Can (terminal.sexy)'
config.color_scheme = 'Andromeda'
-- config.color_scheme = 'catppuccin-mocha'
-- config.color_scheme = 'Chalk (dark) (terminal.sexy)'
-- config.color_scheme = 'Ciapre'

-- config.color_scheme = 'Circus (base16)'


-- Remove window decorations and tab bar
config.window_decorations = "RESIZE"
config.use_fancy_tab_bar = true
-- config.enable_tab_bar = false

-- Add transparency
-- config.window_background_opacity = 0.93

local bg_color_opacity_options = {0.1, 0.3, 0.5, 0.65, 0.85, 1}

local wallpapers = {
      "C:\\Users\\harshwar\\OneDrive - Advanced Micro Devices Inc\\Pictures\\wallpapers\\GOJO4.jpg",
      "C:\\Users\\harshwar\\OneDrive - Advanced Micro Devices Inc\\Pictures\\wallpapers\\GOKU_UI.jpg",
      "C:\\Users\\harshwar\\OneDrive - Advanced Micro Devices Inc\\Pictures\\wallpapers\\Gojo1.jpg",
      "C:\\Users\\harshwar\\OneDrive - Advanced Micro Devices Inc\\Pictures\\wallpapers\\GOKU2.jpg",
}

-- Add background image with gradient
config.background = {
  {
    source = {
      File = wallpapers[1],
    },
    hsb = {
      hue = 1,
      saturation = 1.3,
      brightness = 1,
    },
    width = "100%",
    height = "100%",
  },
  {
    source = {
      Gradient = {
        colors = { wezterm.color.get_builtin_schemes()[config.color_scheme].background, '#ffffff01' },
        -- colors = { '#00fe08ff', '#ffffff04' },
        orientation = { Radial = {
            cx = 0.15,
            cy = 0.25,
            radius = 1.5
        } },
      },
    },
    width = "100%",
    height = "100%",
    opacity = 0.6
  },
  {
    source = {
      Color = wezterm.color.get_builtin_schemes()[config.color_scheme].background,
    },
    width = "100%",
    height = "100%",
    -- opacity = 0.65,
    opacity = bg_color_opacity_options[4],
    -- comment = "foreground color over wallpaper"
  },
}

config.window_padding = {
  left = '1.5cell',
  right = '1cell',
  top = '0.5cell',
  bottom = '0.5cell',
}

config.hide_tab_bar_if_only_one_tab = true


config.mouse_bindings = {
    {
      event = { Up = { streak = 1, button = "Right" } },
      mods = "NONE",
      action = wezterm.action.PasteFrom("Clipboard"),
    }
    -- {
    --   event = { Up = { streak = 1, button = "Left" } },
    --   mods = "NONE",
    --   action = wezterm.action_callback(function(window, pane)
    --     local text = window:get_selection_text_for_pane(pane, "ClipboardAndPrimarySelection")
    --     wezterm.log_info("Double-clicked selection (ClipboardAndPrimarySelection): " .. (text or "<none>"))
    --   end),
    -- }
}

-- Remove space and newline from word boundaries to help with wrapped paths
-- config.selection_word_boundary = " \n\t{}[]()\"'`,;:│"
config.selection_word_boundary = " \t()[]{}'\""

-- Keybinding to toggle through color schemes
local color_schemes = {
  'Andromeda',
  'Batman',
  'Catch Me If You Can (terminal.sexy)',
  'catppuccin-mocha',
  'Chalk (dark) (terminal.sexy)',
  'Ciapre',
  'Circus (base16)',
}

local function get_next_scheme(current)
  for i, name in ipairs(color_schemes) do
    if name == current then
      return color_schemes[(i % #color_schemes) + 1]
    end
  end
  return color_schemes[1]
end

-- Custom event to toggle color scheme. Fire it `config.keys`.
wezterm.on('toggle-color-scheme', function(window, pane)
  local overrides = window:get_config_overrides() or {}
  local current = overrides.color_scheme or config.color_scheme
  overrides.color_scheme = get_next_scheme(current)
  wezterm.log_info('Switching color scheme to: ' .. overrides.color_scheme)
  window:set_config_overrides(overrides)
end)


-- Custom event to toggle wallpaper opacity with direction
wezterm.on('toggle-wallpaper-opacity', function(window, pane, direction)
  local overrides = window:get_config_overrides() or {}
  local current_bg = overrides.background or config.background

  local curr_opacity = current_bg[3].opacity
  local current_index = 1
  
  -- Find current opacity index
  for i, value in ipairs(bg_color_opacity_options) do
    if curr_opacity == value then
      current_index = i
      break
    end
  end

  local new_index
  if direction == 'increase' then
    -- Increase opacity (higher value)
    new_index = math.min(current_index + 1, #bg_color_opacity_options)
  else
    -- Decrease opacity (lower value)  
    new_index = math.max(current_index - 1, 1)
  end
  
  local new_opacity = bg_color_opacity_options[new_index]
  wezterm.log_info("Switching bg_opacity to:", new_opacity)
  
  current_bg[3].opacity = new_opacity
  overrides.background = current_bg
  window:set_config_overrides(overrides)
end)


wezterm.on('toggle-wallpaper', function(window, pane)
  local overrides = window:get_config_overrides() or {}
  local current_bg = overrides.background or config.background

  local curr_opacity = current_bg[3].opacity
  
  for i, value in ipairs(bg_color_opacity_options) do
    if curr_opacity == value then
      curr_opacity = bg_color_opacity_options[(i % #bg_color_opacity_options) + 1]
      break
    end
  end
  -- wezterm.log_info("Switching bg_opacity to:", curr_opacity)
  current_bg[3].opacity = curr_opacity
  overrides.background = current_bg
  window:set_config_overrides(overrides)

  end)

-- Add this event handler somewhere above:
wezterm.on('toggle-font-size', function(window, pane)
  local overrides = window:get_config_overrides() or {}
  local current_size = overrides.font_size or config.font_size
  overrides.font_size = (current_size == 11) and 5 or 11
  window:set_config_overrides(overrides)
end)

-- timeout_milliseconds defaults to 1000 and can be omitted
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }
-- Add key bindings for better selection
config.keys = {
  -- Quick select for pattern-based selection
  {
    key = 'h',
     mods = 'LEADER',
    action =  wezterm.action({ EmitEvent = 'toggle-color-scheme' }),
  },
  {
    key = "B",
     mods = 'LEADER',
    action = wezterm.action_callback(function(window, pane)
      wezterm.emit('toggle-wallpaper-opacity', window, pane, 'decrease')
    end),
  },
  {
    key = "b",
     mods = 'LEADER',
    action = wezterm.action_callback(function(window, pane)
      wezterm.emit('toggle-wallpaper-opacity', window, pane, 'increase')
    end),
  },
  {
    key = "j",
     mods = 'LEADER',
    action = wezterm.action({ EmitEvent = 'toggle-wallpaper' }),
  },
  {
    key = "z",
    mods = 'LEADER',
    action = wezterm.action({ EmitEvent = 'toggle-font-size' }),
  },
  {
    key = "Enter",
    mods = "CTRL|SHIFT",
    action = wezterm.action_callback(function(window, pane)
      local text = pane:get_logical_lines_as_text()
      wezterm.log_info("Pane content:\n" .. (text or "<none>"))

      -- Write the content to a file
      local file_path = "C:\\Users\\harshwar\\wezterm_pane_output.txt"
      local file, err = io.open(file_path, "w")
      if file then
        file:write(text or "")
        file:close()
        wezterm.log_info("Pane content written to: " .. file_path)
      else
        wezterm.log_error("Failed to write to file: " .. (err or "unknown error"))
      end
    end),
  }
}

config.ssh_domains = {
  {
    -- This name identifies the domain
    name = 'vdi.server',
    -- The hostname or address to connect to. Will be used to match settings
    -- from your ssh config file
    -- remote_address = 'xhdharshwar41x',
    remote_address = 'host',
    -- The username to use on the remote host
    username = 'username',
  },
}



-- Configure copy behavior
config.canonicalize_pasted_newlines = "None"

-- config.debug_key_events = true

-- Finally, return the configuration to wezterm:
return config

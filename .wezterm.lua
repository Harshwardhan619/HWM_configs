-- Pull in the wezterm API
local wezterm = require 'wezterm'

local mux = wezterm.mux


-- This will hold the configuration.
local config = wezterm.config_builder()


-- Rounded or Square Style Tabs

-- change to square if you don't like rounded tab style
local tab_style = "square"

-- leader active indicator prefix
local leader_prefix = utf8.char(0x1f30a) -- ocean wave



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

-- Might be useful for tmux
-- Remove space and newline from word boundaries to help with wrapped paths
-- config.selection_word_boundary = " \n\t{}[]()\"'`,;:│"
-- config.selection_word_boundary = " \t()[]{}'\""

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

  -- Find current wallpaper index
  local current_file = current_bg[1].source.File
  local current_index = 1
  for i, file in ipairs(wallpapers) do
    if file == current_file then
      current_index = i
      break
    end
  end

  -- Get next wallpaper index
  local next_index = (current_index % #wallpapers) + 1
  local next_file = wallpapers[next_index]
  wezterm.log_info("Switching wallpaper to:", next_file)

  -- Update wallpaper in background config
  current_bg[1].source.File = next_file
  overrides.background = current_bg
  window:set_config_overrides(overrides)
end)

-- Add this event handler somewhere above:
wezterm.on('toggle-font-size', function(window, pane)
  local size1 = 11
  local size2 = 5
  local overrides = window:get_config_overrides() or {}
  local current_size = overrides.font_size or config.font_size
  
  -- Choose the size with the highest difference from current
  local diff1 = math.abs(current_size - size1)
  local diff2 = math.abs(current_size - size2)
  
  if diff1 > diff2 then
    overrides.font_size = size1
  else
    overrides.font_size = size2
  end
  
  wezterm.log_info("Font size changed from " .. current_size .. " to " .. overrides.font_size)
  window:set_config_overrides(overrides)
end)


-- timeout_milliseconds defaults to 1000 and can be omitted
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 2000 }
config.keys = {
  -- Custom WezTerm keybindings (using non-conflicting keys)
  {
    key = 't',  -- Changed from 'h' to avoid conflict with tmux navigation
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
    key = "w",  -- Changed from 'j' to avoid conflict with tmux navigation
     mods = 'LEADER',
    action = wezterm.action({ EmitEvent = 'toggle-wallpaper' }),
  },
  {
    key = "f",  -- Changed from 'z' to avoid conflict with tmux zoom
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
  },
  
  {
      mods = "LEADER",
      key = "c",
      action = wezterm.action.SpawnTab "CurrentPaneDomain",
  },
  {
      mods = "LEADER",
      key = "x",
      action = wezterm.action.CloseCurrentPane { confirm = true }
  },
  { mods = "LEADER", key = "p", action = wezterm.action.ActivateTabRelative(-1) }, 
  { mods = "LEADER", key = "n", action = wezterm.action.ActivateTabRelative(1) },

  { mods = "SHIFT", key = "LeftArrow", action = wezterm.action.ActivateTabRelative(-1) }, 
  { mods = "SHIFT", key = "RightArrow", action = wezterm.action.ActivateTabRelative(1) },

  { mods = "LEADER|SHIFT", key = "|", action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" }},
  { mods = "LEADER", key = "\\", action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" }},
  {
      mods = "LEADER",
      key = "-",
      action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" }
  },
  { mods = "LEADER", key = "h", action = wezterm.action.ActivatePaneDirection "Left" }, 
  { mods = "LEADER", key = "j", action = wezterm.action.ActivatePaneDirection "Down" }, 
  { mods = "LEADER", key = "k", action = wezterm.action.ActivatePaneDirection "Up" }, 
  { mods = "LEADER", key = "l", action = wezterm.action.ActivatePaneDirection "Right" },

  { mods = "ALT", key = "LeftArrow", action = wezterm.action.ActivatePaneDirection "Left" }, 
  { mods = "ALT", key = "DownArrow", action = wezterm.action.ActivatePaneDirection "Down" }, 
  { mods = "ALT", key = "UpArrow", action = wezterm.action.ActivatePaneDirection "Up" }, 
  { mods = "ALT", key = "RightArrow", action = wezterm.action.ActivatePaneDirection "Right" },

  {
      mods = "LEADER",
      key = "LeftArrow",
      action = wezterm.action.AdjustPaneSize { "Left", 5 }
  },
  {
      mods = "LEADER",
      key = "RightArrow",
      action = wezterm.action.AdjustPaneSize { "Right", 5 }
  },
  {
      mods = "LEADER",
      key = "DownArrow",
      action = wezterm.action.AdjustPaneSize { "Down", 5 }
  },
  {
      mods = "LEADER",
      key = "UpArrow",
      action = wezterm.action.AdjustPaneSize { "Up", 5 }
  },
  
  -- Zoom/unzoom pane (toggle maximize)
  {
      mods = "LEADER",
      key = "z",
      action = wezterm.action.TogglePaneZoomState
  },

-- Copy mode (like tmux copy mode)
  { key = "[",
  mods = "LEADER",
  action = wezterm.action.ActivateCopyMode
  },
  {
    key = 'x',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ActivateCopyMode,
  },
  
  -- Paste
  {
    key = ']',
    mods = 'LEADER',
    action = wezterm.action.PasteFrom 'Clipboard',
  },
  
  -- Reload config (like tmux source-file)
  {
    key = 'r',
    mods = 'LEADER',
    action = wezterm.action.ReloadConfiguration,
  },
  
  -- Rename tab (like tmux rename-window)
  {
    key = ',',
    mods = 'LEADER',
    action = wezterm.action.PromptInputLine {
      description = 'Enter new name for tab',
      -- initial_value = 'My Tab Name',
      action = wezterm.action_callback(function(window, pane, line)
        -- line will be `nil` if they hit escape without entering anything
        -- An empty string if they just hit enter
        -- Or the actual line of text they wrote
        if line then
          window:active_tab():set_title(line)
        end
      end),
    },
  },
  
  -- Session/Workspace management (like tmux sessions)
  {
    key = 's',
    mods = 'LEADER',
    action = wezterm.action.ShowLauncherArgs {
      flags = 'FUZZY|WORKSPACES',
    },
  },
  
  -- Create new workspace (like tmux new-session)
  {
    key = 'S',
    mods = 'LEADER',
    action = wezterm.action.PromptInputLine {
      description = 'Enter name for new workspace',
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:perform_action(
            wezterm.action.SwitchToWorkspace {
              name = line,
            },
            pane
          )
        end
      end),
    },
  },
  
  -- Rename current workspace/session (like tmux rename-session)
  {
    key = '$',
    mods = 'LEADER|SHIFT',
    action = wezterm.action_callback(function(window, pane)
      local current_workspace = window:active_workspace()
      window:perform_action(
        wezterm.action.PromptInputLine {
          description = 'Enter new name for workspace "' .. current_workspace .. '":',
          action = wezterm.action_callback(function(window, pane, line)
            if line then
              local workspace_names = wezterm.mux.get_workspace_names()
              wezterm.log_info(workspace_names)

              local exists = false
              for _, name in ipairs(workspace_names) do
                if line == name then
                  exists = true
                  break
                end
              end

              if exists then
                wezterm.log_info("Workspace '" .. line .. "' already exists.")
                window:toast_notification("WezTerm", "Workspace '" .. line .. "' already exists.", nil, 4000)
              else
                wezterm.log_info("Renaming workspace from '" .. current_workspace .. "' to '" .. line .. "'")
                -- Switch to new workspace with the new name
                wezterm.mux.rename_workspace(
                  wezterm.mux.get_active_workspace(),
                  line
                )
              end
            end
          end),
        },
        pane
      )
    end),
  },
  
  -- Detach from multiplexer (like tmux detach)
  {
    key = 'd',
    mods = 'LEADER',
    action = wezterm.action.DetachDomain 'CurrentPaneDomain',
  }
}

for i = 0, 9 do
  -- leader + number to activate that tab
  table.insert(config.keys, {
      key = tostring(i),
      mods = "LEADER",
      action = wezterm.action.ActivateTab(i-1),
  })  
end

-- tab bar
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.tab_and_split_indices_are_zero_based = false
config.show_new_tab_button_in_tab_bar = false

-- Global variable to store current workspace name
local current_workspace = "default"


--[[
============================
Leader Active Indicator
============================
]] --

status_bg = "#262626"      -- Dark background
tabname_bg = "#907aa9"
icons_bg = "#797593"

-- config.automatically_reload_config = true

wezterm.on("update-status", function(window, _)
    -- Update global workspace name
    current_workspace = window:active_workspace()
    
    -- Status bar color scheme - Andromeda inspired
    local workspace_bg = "#89b4fa"   -- Blue accent for workspace
    local workspace_fg = "#575279"   -- Dark text on blue
    local leader_bg = "#9d1212"    -- Pink accent for leader
    local leader_fg = leader_bg
    local arrow_color = "#575279"    -- Subtle arrow color
    
    -- leader inactive
    local solid_left_arrow = ""
    local arrow_foreground = { Foreground = { Color = arrow_color } }
    local arrow_background = { Background = { Color = status_bg } }
    local prefix = ""

    -- leader is active
    if window:leader_is_active() then
        prefix = " " .. leader_prefix

        if tab_style == "rounded" then
            solid_left_arrow = wezterm.nerdfonts.ple_right_half_circle_thick
        else
            solid_left_arrow = wezterm.nerdfonts.pl_left_hard_divider
        end

        local tabs = window:mux_window():tabs_with_info()

        if tab_style ~= "rounded" then
            for _, tab_info in ipairs(tabs) do
                if tab_info.is_active and tab_info.index == 0 then
                    arrow_background = { Foreground = { Color = leader_bg } }
                    solid_left_arrow = wezterm.nerdfonts.pl_right_hard_divider
                    break
                end
            end
        end
    end

    -- Set left status with workspace name and leader indicator
    window:set_left_status(wezterm.format {
      -- { Background = { Color = window:leader_is_active() and leader_bg or status_bg } },
      { Text = " " },
      { Foreground = { Color = window:leader_is_active() and leader_fg or "#cdd6f4" } },
      { Text = window:leader_is_active() and "👀" or " " },
      { Background = { Color = status_bg } },
      { Foreground = { Color = workspace_fg } },
        { Text = current_workspace .. "" },

        -- { Text = prefix },
        -- arrow_foreground,
        -- arrow_background,
        -- { Text = solid_left_arrow }
    })
    
    -- Set right status with time and additional info
    local time = wezterm.strftime("%H:%M")
    local date = wezterm.strftime("%Y-%m-%d")
    
    local pane = window:active_pane()
    local domain_name = pane:get_domain_name()
    local hostname

    if domain_name and domain_name ~= "local" then
        -- For SSH domains, use the domain name or extract from remote_address
        hostname = domain_name  -- or parse from ssh_domains config
    else
        -- For local sessions, use environment variables
        hostname = os.getenv("COMPUTERNAME") or os.getenv("HOSTNAME") or "unknown"
    end
    
    -- Get username and hostname
    local username = os.getenv("USERNAME") or os.getenv("USER") or "unknown"
    

    local cwd = window:active_pane():get_current_working_dir()
    local cwd_folder = "~"
    if cwd then
        local path = cwd.file_path or cwd
        if type(path) == "string" then
            -- Extract just the folder name from the path
            cwd_folder = path:match("([^/\\]+)[/\\]*$") or path:match("([^/\\]+)$") or "~"
        end
    end

    cwd_len_threshold = 30
    if #cwd_folder > cwd_len_threshold then
        cwd_folder = cwd_folder:sub(1, cwd_len_threshold) .. "..."
    end

    window:set_right_status(wezterm.format {
        { Background = { Color = status_bg } },
        { Foreground = { Color = "#f9e2af" } },
        { Text = "  " .. username },
        { Foreground = { Color = icons_bg } },
        { Text = " | " },
        { Foreground = { Color = "#d56b84" } },
        {Text = "󰒋 " .. hostname },
        { Foreground = { Color = icons_bg } },
        { Text = " | " },
        { Background = { Color = status_bg } },
        -- { Foreground = { Color = icons_bg } },
        { Foreground = { Color = "#56949f" } },
        { Text = "󰃰 " },
        { Text =  date .. "" },
        { Background = { Color = status_bg } },
        
        { Text = " " ..  time },
        { Foreground = { Color = icons_bg } },
        { Text = " | " },
        { Foreground = { Color = "#ea9d34" } },
        { Text = " " .. cwd_folder .. " "},
    })
end)

-- Custom tab bar formatting - clean tab titles with active tab highlighting
wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  local title = tab.tab_title

    -- Active tab: orange text, normal background
    local str_var = string.format(" %d. %s |", tab.tab_index + 1, title)
    -- wezterm.log_info("Tab Title: " .. str_var)
    return wezterm.format {
      { Background = { Color = status_bg } },
      { Foreground = { Color = tab.is_active and "#ea9d34" or tabname_bg } },
      { Text = str_var },
    }

end)


config.colors = {
  tab_bar = {
    background = status_bg
    -- background = "#ea9d34"
  }  
}


-- add paths to quick select for fast copy
config.quick_select_patterns = {
  -- Match Unix and Windows file paths
  [[([a-zA-Z]:[\\/][\w\-.\\\/]+)]],      -- Windows paths like C:\Users\file.txt
  [[(/[^\s"']+)]],                       -- Unix paths like /home/user/file.txt
  [[https?://[^\s"']+]],  -- URLs
}


-- local resurrect = wezterm.plugin.require("file:///C:\\Users\\harshwar\\AppData\\Roaming\\wezterm\\plugins\\resurrects_wezterm")

-- start the terminal maximized
wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

config.scrollback_lines = 5000

-- config.debug_key_events = true

-- Finally, return the configuration to wezterm:
return config
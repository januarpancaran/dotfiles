-- Autostart Configuration
-- Programs and commands to execute on Hyprland start
-- Includes workspace compacting logic

-- Workspace compacting function
-- Automatically renumbers workspaces to be sequential (1, 2, 3...) with no gaps
local function compact_workspaces()
  -- Re-entrancy guard: don't debounce/restart if we're currently compacting
  if compact_running then
    return
  end

  -- Debouncing: cancel previous timer if it exists
  if compact_timer ~= nil and compact_timer.cancel ~= nil then
    compact_timer:cancel()
  end

  compact_timer = hl.timer(function()
    compact_running = true

    local workspaces = hl.get_workspaces()
    local current_ws = hl.get_active_workspace().id

    -- Build a map of workspace IDs with their window counts
    local ws_map = {}
    for _, ws in ipairs(workspaces) do
      if ws.id >= 1 then
        ws_map[ws.id] = ws.windows
      end
    end

    -- Find all occupied workspaces (sorted)
    local occupied = {}
    for id, windows in pairs(ws_map) do
      if windows > 0 then
        table.insert(occupied, id)
      end
    end
    table.sort(occupied)

    -- Check if compacting is needed
    local needs_compact = false
    for i, id in ipairs(occupied) do
      if id ~= i then
        needs_compact = true
        break
      end
    end

    if not needs_compact then
      compact_timer = nil
      compact_running = false
      return
    end

    -- Check if workspace 1 is empty (needs special focus handling)
    local ws1_empty = (ws_map[1] == nil or ws_map[1] == 0) and #occupied > 0

    -- Move windows to compact positions.
    -- Re-fetch workspaces each iteration so we find the correct workspace
    -- object even after prior moves have changed IDs (e.g. gaps like 1, 4).
    for i, source_id in ipairs(occupied) do
      if source_id ~= i then
        local workspace = nil
        for _, ws in ipairs(hl.get_workspaces()) do
          if ws.id == source_id then
            workspace = ws
            break
          end
        end

        if workspace ~= nil then
          for _, window in ipairs(workspace:get_windows()) do
            hl.dispatch(hl.dsp.window.move({
              window = window,
              workspace = i,
            }))
          end
        end
      end
    end

    -- If workspace 1 was empty and we're on it, stay on workspace 1
    if ws1_empty and current_ws == 1 then
      hl.dispatch(hl.dsp.focus({ workspace = 1 }))
    end

    compact_timer = nil
    compact_running = false
  end, { timeout = 200, type = "oneshot" })
end

-- Event handler that calls compact_workspaces
local function compact_event()
  if compact_workspaces ~= nil then
    compact_workspaces()
  end
end

-- Initialize on Hyprland start
hl.on("hyprland.start", function()
  compact_timer = nil
  compact_running = false

  -- Launch startup programs
  hl.exec_cmd("/usr/libexec/polkit-gnome-authentication-agent-1")
  hl.exec_cmd("noctalia")
  hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme Dracula")
  hl.exec_cmd("gsettings set org.gnome.desktop.interface icon-theme Tela-nord-dark")
  hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-theme Bibata-Modern-Classic")
  hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme prefer-dark")
end)

-- Trigger workspace compacting on various events
hl.on("window.close", compact_event)
hl.on("window.move_to_workspace", compact_event)
hl.on("workspace.active", compact_event)

-- Re-initialize after sleep/wake
hl.on("monitor.added", function()
  compact_workspaces = compact_workspaces  -- Re-assign function
  compact_timer = nil
  compact_running = false
end)

-- Re-initialize after config reload (e.g. after a `rebuild`)
hl.on("config.reloaded", function()
  compact_workspaces = compact_workspaces  -- Re-assign function
  compact_timer = nil
  compact_running = false
end)

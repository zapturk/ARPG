-- Variables
local door_manager = {}

-- Include scripts
require("scripts/multi_events")

-- Open doors when a block in the room are moved
function door_manager:open_when_block_moved(map, block_prefix, door_prefix)

  local function block_on_moved(block)
    if not block.is_moved then
      block.is_moved = true
      map:open_doors(door_prefix)
      -- audio_manager:play_sound("misc/secret1")
    end
  end
  for block in map:get_entities(block_prefix) do
    block.is_moved = false
    block.on_moved = block_on_moved
  end

end

-- Open doors when a switch in the room is activated
function door_manager:open_when_switch_activated(map, switch_prefix, door_prefix)

  local function switch_on_activated(switch)
    if not switch.is_activated then
      switch.is_activated = true
      map:open_doors(door_prefix)
      --audio_manager:play_sound("misc/secret1")
    end
  end

  local function switch_on_inactivated(switch)
    if switch.is_activated then
      switch.is_activated = false
      map:close_doors(door_prefix)
      --audio_manager:play_sound("misc/secret1")
    end
  end 

  for switch in map:get_entities(switch_prefix) do
    switch.is_activated = false
    switch.on_activated = switch_on_activated
    switch.on_inactivated = switch_on_inactivated
  end

end


return door_manager
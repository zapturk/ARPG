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


return door_manager
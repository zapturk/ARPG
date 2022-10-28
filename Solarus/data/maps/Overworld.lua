-- Lua script of map Overworld.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()
local hero = map:get_hero()

-- Event called at initialization time, as soon as this map is loaded.
function map:on_started()
  game:set_value("MapHasKey", false)
  -- You can initialize the movement and sprites of various
  -- map entities here.
end

-- Event called after the opening transition effect of the map,
-- that is, when the player takes control of the hero.
function map:on_opening_transition_finished()

end

function dungeon_1_lock:on_interaction()

  if false then
    game:start_dialog("test")
  else
    hero:freeze()
    local camera = map:get_camera()
    local shake_config = {
          count = 32,
          amplitude = 2,
          speed = 90
      }
    camera:shake(shake_config, resume)
    
  end

end

function resume()
  door_dungeon_1:open();
  hero:unfreeze()
end
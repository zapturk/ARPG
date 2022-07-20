-- Lua script of map HeroCave.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()

-- Include scripts
require("scripts/multi_events")
local door_manager = require("scripts/maps/door_manager")

-- Event called at initialization time, as soon as this map is loaded.
function map:on_started()
  door_manager:open_when_block_moved(map, "block_1", "door_1")

  -- You can initialize the movement and sprites of various
  -- map entities here.
end

-- Event called after the opening transition effect of the map,
-- that is, when the player takes control of the hero.
function map:on_opening_transition_finished()

end

--function block_1:on_moved()
-- door_1:open()
--end

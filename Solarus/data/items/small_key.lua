-- Lua script of item "small key".
-- This script is executed only once for the whole game.

-- Variables
local item = ...

-- Include scripts
local audio_manager = require("scripts/audio_manager")

-- Event called when the game is initialized.
function item:on_created()

  item:set_shadow("small")
  item:set_brandish_when_picked(false)
  item:set_sound_when_picked(nil)
  item:set_sound_when_brandished(nil)

end

function item:on_pickable_created(pickable)

  local old_sprite=pickable:get_sprite("treasure")
  pickable:remove_sprite(old_sprite)
  pickable:create_sprite("entities/items/small_key", "treasure")
end

function item:on_obtaining(variant, savegame_variable)
  local map = item:get_map()
  local hero = map:get_hero()
  -- Sound
  --if hero:get_state() == "treasure" then
  --  audio_manager:play_sound("items/fanfare_item")
  --else
  --  audio_manager:play_sound("items/get_item2")
  --end
  -- Add key
  item:get_game():add_small_key()

end
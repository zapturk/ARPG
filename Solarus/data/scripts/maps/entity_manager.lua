local entity_manager = {}
local audio_manager = require("scripts/audio_manager")
local common_actions = require("enemies/lib/common_actions")

local function on_fall_finished(base_entity, falling_entity)

  base_entity.is_hurt_silently = true -- Workaround : Don't play generic sounds added by enemy meta script.

  -- Manually call death events on the base entity as enemy ones may be needed for some puzzles.
  if base_entity.on_dying then
    base_entity:on_dying()
  end

  falling_entity:remove()
  base_entity:remove()

  if base_entity.on_dead then
    base_entity:on_dead()
  end
end

function entity_manager:fall(base_entity, falling_entity)
  local sprite = falling_entity:get_sprite()
  if sprite:has_animation("falling") then
    audio_manager:play_sound("enemies/enemy_fall")
    sprite:set_animation("falling", function()
        on_fall_finished(base_entity, falling_entity)
      end)
  else
    --print "Warning : \"falling\" animation not found"
    on_fall_finished(base_entity, falling_entity)
  end
end

function entity_manager:create_falling_entity(base_entity, sprite_name)
  --print "DOWN WE GOOOOOOooooooo........ !"
  local x, y, layer = base_entity:get_position()

  if not base_entity:is_enabled() then
    return
  end
  base_entity:set_enabled(false)
  if not sprite_name then
    if base_entity:get_type()=="enemy" then
      sprite_name="enemies/"..base_entity:get_breed()
    else
      sprite_name=base_entity:get_sprite():get_animation_set()
    end
  end
  local falling_entity = base_entity:get_map():create_custom_entity({
      name="falling_entity_actor",
      sprite = sprite_name,
      x = x,
      y = y,
      width = 16,
      height = 16,
      layer = layer,
      direction = 0,
    })
  if falling_entity then --will be nil if the map is in finishing state
    falling_entity:set_can_traverse_ground("hole", true)
    entity_manager:fall(base_entity, falling_entity)
  end
end

return entity_manager
-- Lua script of item "random".
-- This script is executed only once for the whole game.

-- Variables
local item = ...

-- When it is created, this item creates another item randomly chosen
-- and then destroys itself.

-- Probability of each item between 0 and 1000.
local probabilities = {
  [{ "gem", 1 }]      = 50,   -- 1 rupee.
  [{ "gem", 2 }]      = 15,   -- 5 rupees.
  [{ "heart", 1}]       = 100,  -- Heart.
}

-- Event called when a pickable treasure representing this item
-- is created on the map.
function item:on_pickable_created(pickable)

  local game = item:get_game()
  local treasure_name, treasure_variant = self:choose_random_item()
  if treasure_name ~= nil then
    local map = pickable:get_map()
    local x, y, layer = pickable:get_position()
    map:create_pickable{
      layer = layer,
      x = x,
      y = y,
      treasure_name = treasure_name,
      treasure_variant = treasure_variant,
    }
  end
  pickable:remove()
  function pickable:get_final_pickable()
    return pickable
  end
  game.charm_treasure_is_loading = nil
end

-- Returns an item name and variant.
function item:choose_random_item()
  local random = math.random(1000)
  local sum = 0
  for key, probability in pairs(probabilities) do
    sum = sum + probability
    if random < sum then
      return key[1], key[2]
    end
  end

  return nil
  
end
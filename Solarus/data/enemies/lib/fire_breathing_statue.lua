local behavior = {}

-- Behavior of a fixed enemy who shoots fireballs.

-- Example of use from an enemy script:

-- local enemy = ...
-- local behavior = require("enemies/lib/fire_breathing_statue")
-- local properties = {
--   sprite = "enemies/medusa",
--   projectile_breed = "fireball_small_triple_red",
--   projectile_sound = "zora",
--   detection_distance = 500,
--   shooting_delay = 1300,
--   fire_x = 0,
--   fire_y = 0,
-- }
-- behavior:create(enemy, properties)

local audio_manager = require("scripts/audio_manager")
local common_actions = require("enemies/lib/common_actions")

function behavior:create(enemy, properties)

  local children = {}

  -- Set default properties.
  if properties.detection_distance == nil then
    properties.detection_distance = 500
  end
  if properties.shooting_delay == nil then
    properties.shooting_delay = 5000
  end
  if properties.fire_x == nil then
    properties.fire_x = 0
  end
  if properties.fire_y == nil then
    properties.fire_y = 0
  end

  enemy:register_event("on_created", function(enemy)

    enemy:set_life(1)
    enemy:set_damage(0)
    enemy:create_sprite(properties.sprite)
    enemy:set_pushed_back_when_hurt(false)
    enemy:set_size(16, 16)
    enemy:set_origin(8, 13)
    enemy:set_can_attack(false)
    enemy:set_optimization_distance(1000)
    enemy:set_invincible()

    enemy:set_shooting(true)
  end)

  enemy:register_event("on_restarted", function(enemy)

    local map = enemy:get_map()
    local hero = map:get_hero()
    sol.timer.start(enemy, properties.shooting_delay, function()
      if not enemy.shooting then
        return true
      end

      if enemy:get_distance(hero) < properties.detection_distance and enemy:is_in_same_region(hero) then

        if not map.fire_breath_recent_sound then
          audio_manager:play_sound(properties.projectile_sound)
          -- Avoid loudy simultaneous sounds if there are several fire breathing enemies.
          map.fire_breath_recent_sound = true
          sol.timer.start(map, 200, function()
            map.fire_breath_recent_sound = nil
          end)
        end

        children[#children + 1] = enemy:create_enemy({
          name = (enemy:get_name() or enemy:get_breed()) .. "_" .. properties.projectile_breed,
          breed = properties.projectile_breed,
          x = properties.fire_x,
          y = properties.fire_y,
          layer = map:get_max_layer()
        })
        children[#children]:set_layer_independent_collisions(true)
      end
      return true  -- Repeat the timer.
    end)
  end)

  -- Suspends or restores shooting fireballs.
  function enemy:set_shooting(shooting)
    enemy.shooting = shooting
  end

  enemy:register_event("on_removed", function(enemy)

    for _, child in ipairs(children) do
      child:start_death()
    end
  end)

end

return behavior
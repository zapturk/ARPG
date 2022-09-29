----------------------------------
--
-- Add basic projectile methods and events to an enemy.
--
-- Methods : enemy:straight_go([angle, [speed]])
--
-- Events :  enemy:on_hit()
--
-- Usage : 
-- local my_enemy = ...
-- local behavior = require("enemies/lib/projectile")
-- local main_sprite = enemy:create_sprite("my_enemy_main_sprite")
-- behavior.apply(my_enemy, main_sprite)
--
----------------------------------

local behavior = {}

function behavior.apply(enemy, sprite)

  require("enemies/lib/common_actions").learn(enemy)
  local audio_manager = require("scripts/audio_manager")

  local game = enemy:get_game()
  local map = enemy:get_map()
  local hero = map:get_hero()
  local camera = map:get_camera()

  local is_initialized = false
  local default_speed = 192

  -- Call the enemy:on_hit() callback if the enemy still can attack, and remove the entity if it doesn't return false.
  local function hit_behavior()

    if enemy:get_can_attack() and (not enemy.on_hit or enemy:on_hit() ~= false) then
      enemy:start_death()
    end
  end

  -- Start going to the given angle, or to the hero if nil.
  function enemy:straight_go(angle, speed)

    local movement = sol.movement.create("straight")
    movement:set_angle(angle or enemy:get_angle(hero))
    movement:set_speed(speed or default_speed)
    movement:set_smooth(false)
    movement:start(enemy)
    sprite:set_direction(movement:get_direction4())

    function movement:on_obstacle_reached()
      hit_behavior()
    end

    return movement
  end

  -- Remove any projectile if its main sprite is completely out of the screen.
  enemy:register_event("on_position_changed", function(enemy)

    if is_initialized then -- Workaround: on_position_changed() is called before on_restarted(), make sure it won't.
      if not camera:overlaps(enemy:get_max_bounding_box()) then
        enemy:start_death()
      end
    end
  end)

  enemy:register_event("on_restarted", function(enemy)
    is_initialized = true
  end)

  -- Check if the projectile should be destroyed when the hero is touched. 
  enemy:register_event("on_attacking_hero", function(enemy, hero, enemy_sprite)

    if not hero:is_shield_protecting(enemy) and not hero:is_blinking() then
      hero:start_hurt(enemy, enemy_sprite, enemy:get_damage())
    end
    hit_behavior()
  end)
end

return behavior
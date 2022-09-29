----------------------------------
--
-- Add some basic weapon abilities to an enemy.
-- There is no passive behavior without an explicit method call when learning this to an enemy.
--
-- Methods : enemy:hold_weapon([sprite_name, [reference_sprite, [x_offset, [y_offset]]]])
--           enemy:throw_projectile(projectile_name, [throwing_duration, [x_offset, [y_offset, [on_throwed_callback]]]])
--
-- Usage : 
-- local my_enemy = ...
-- local weapons = require("enemies/lib/weapons")
-- weapons.learn(my_enemy)
--
----------------------------------

local weapons = {}

function weapons.learn(enemy)

  local common_actions = require("enemies/lib/common_actions")
  local game = enemy:get_game()
  local map = enemy:get_map()
  local hero = map:get_hero()
  local quarter = math.pi * 0.5

  common_actions.learn(enemy)

  -- Make the enemy hold a basic weapon that push back both the enemy and hero back on hit by hero hand weapons.
  function enemy:hold_weapon(sprite_name, reference_sprite, x_offset, y_offset)

    local enemy_x, enemy_y, enemy_layer = enemy:get_position()
    reference_sprite = reference_sprite or enemy:get_sprite()

    -- Create the weapon as welded enemy.
    local weapon = map:create_enemy({
      name = (enemy:get_name() or enemy:get_breed()) .. "_weapon",
      breed = "empty", -- Workaround: Breed is mandatory but a non-existing one seems to be ok to create an empty enemy though.
      direction = enemy:get_sprite():get_direction(),
      x = enemy_x,
      y = enemy_y,
      layer = enemy_layer,
      width = 16,
      height = 16
    })
    enemy:start_welding(weapon, x_offset, y_offset)
    common_actions.learn(weapon)
    weapon:set_damage(enemy:get_damage())
    
    -- Synchronize sprites animation and direction.
    local weapon_sprite = weapon:create_sprite(sprite_name or "enemies/" .. enemy:get_breed() .. "/sword")
    weapon_sprite:synchronize(reference_sprite)
    reference_sprite:register_event("on_direction_changed", function(reference_sprite)
      weapon_sprite:set_direction(reference_sprite:get_direction())
    end)
    reference_sprite:register_event("on_animation_changed", function(reference_sprite, name)
      if weapon_sprite:has_animation(name) then
        weapon_sprite:set_animation(name)
      end
    end)

    -- Make weapon disappear when the enemy became invisible on dying.
    enemy:register_event("on_dying", function(enemy)
      sol.timer.start(weapon, 300, function() -- No event when the enemy became invisible, hardcode a timer.
        weapon:start_death()
      end)
    end)

    -- Echo weapon reactions on the enemy.
    local is_pushed_back = false
    local function shock()
      if not is_pushed_back then
        is_pushed_back = true
        enemy:set_invincible()
        enemy:stop_movement()
        enemy:start_shock(hero, 100, 150, weapon_sprite, entity_sprite, function()
          enemy:restart()
        end)
      end
    end
    enemy:register_event("on_restarted", function(enemy)
      is_pushed_back = false
    end)

    weapon:set_hero_weapons_reactions({
    	arrow = "protected",
    	boomerang = "protected",
    	explosion = "protected",
    	sword = shock,
    	thrown_item = "protected",
    	fire = "ignored",
    	jump_on = "ignored",
    	hammer = shock,
    	hookshot = "protected",
    	magic_powder = "ignored",
    	shield = shock,
    	thrust = shock
    })

    return weapon
  end

  -- Throw a projectile when throwing animation finished or duration reached.
  function enemy:throw_projectile(projectile_name, throwing_duration, x_offset, y_offset, on_throwed_callback)

    local sprite = enemy:get_sprite()

    local is_throwed = false
    local function throw()
      if not is_throwed then
        is_throwed = true
        local direction = sprite:get_direction()
        local x, y, layer = enemy:get_position()
        local projectile = map:create_enemy({
          breed = "projectiles/" .. projectile_name,
          x = x + x_offset,
          y = y + y_offset,
          layer = layer,
          direction = direction
        })

        local projectile_sprite = projectile:get_sprite()
        projectile_sprite:set_direction(direction)
        if on_throwed_callback then
          on_throwed_callback()
        end
      end
    end
    for _, sprite in enemy:get_sprites() do
      if sprite:has_animation("throwing") then
        sprite:set_animation("throwing")
      end
    end

    if throwing_duration then
      sol.timer.start(enemy, throwing_duration, function()
        throw()
      end)
    end
  end
end

return weapons
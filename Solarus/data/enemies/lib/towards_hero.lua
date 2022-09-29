local behavior = {}

-- Behavior of an enemy that goes towards the
-- the hero if he sees him, and randomly walks otherwise.
-- The enemy has only one sprite.

-- Example of use from an enemy script:

-- local enemy = ...
-- local behavior = require("enemies/lib/towards_hero")
-- local properties = {
--   sprite = "enemies/globul",
--   life = 1,
--   damage = 2,
--   normal_speed = 32,
--   faster_speed = 32,
--   hurt_style = "normal",
--   push_hero_on_sword = false,
--   pushed_when_hurt = true,
--   ignore_obstacles = false,
--   obstacle_behavior = "flying",
--   detection_distance = 100,
--   movement_create = function()
--     local m = sol.movement.create("random_path")
--     return m
--   end
-- }
-- behavior:create(enemy, properties)

-- The properties parameter is a table.
-- All its values are optional except the sprite.

function behavior:create(enemy, properties)

  local going_hero = false

  -- Set default properties.
  if properties.life == nil then
    properties.life = 2
  end
  if properties.damage == nil then
    properties.damage = 2
  end
  if properties.normal_speed == nil then
    properties.normal_speed = 32
  end
  if properties.faster_speed == nil then
    properties.faster_speed = 48
  end
  if properties.hurt_style == nil then
    properties.hurt_style = "normal"
  end
  if properties.pushed_when_hurt == nil then
    properties.pushed_when_hurt = true
  end
  if properties.push_hero_on_sword == nil then
    properties.push_hero_on_sword = false
  end
  if properties.ignore_obstacles == nil then
    properties.ignore_obstacles = false
  end
  if properties.detection_distance == nil then
    properties.detection_distance = 160
  end
  if properties.obstacle_behavior == nil then
    properties.obstacle_behavior = "normal"
  end
  if properties.movement_create == nil then
    properties.movement_create = function()
      local m = sol.movement.create("random_path")
      return m
    end
  end


    enemy:set_life(properties.life)
    enemy:set_damage(properties.damage)
    enemy:create_sprite(properties.sprite)
    enemy:set_hurt_style(properties.hurt_style)
    enemy:set_pushed_back_when_hurt(properties.pushed_when_hurt)
    enemy:set_push_hero_on_sword(properties.push_hero_on_sword)
    enemy:set_obstacle_behavior(properties.obstacle_behavior)
    enemy:set_size(16, 16)
    enemy:set_origin(8, 13)

  enemy:register_event("on_movement_changed", function(enemy, movement)

    local direction4 = movement:get_direction4()
    local sprite = enemy:get_sprite()
    sprite:set_direction(direction4)
  end)

  enemy:register_event("on_obstacle_reached", function(enemy)

    if not going_hero then
      enemy:go_random()
      enemy:check_hero()
    end
  end)

  enemy:register_event("on_restarted", function(enemy)
    enemy:go_random()
    enemy:check_hero()
  end)

  function enemy:check_hero()

    local hero = enemy:get_map():get_entity("hero")
    local _, _, layer = enemy:get_position()
    local _, _, hero_layer = hero:get_position()
    local near_hero =
        (layer == hero_layer or enemy:has_layer_independent_collisions()) and
        enemy:get_distance(hero) < properties.detection_distance
        enemy:is_in_same_region(hero)

    if near_hero and not going_hero then
      enemy:go_hero()
    elseif not near_hero and going_hero then
      enemy:go_random()
    end

    sol.timer.stop_all(enemy)
    sol.timer.start(enemy, 100, function() enemy:check_hero() end)
  end

  function enemy:go_random()
    going_hero = false
    local m = properties.movement_create()
    if m == nil then
      -- No movement.
      enemy:get_sprite():set_animation("stopped")
      m = enemy:get_movement()
      if m ~= nil then
        -- Stop the previous movement.
        m:stop()
      end
    else
      m:set_speed(properties.normal_speed)
      m:set_ignore_obstacles(properties.ignore_obstacles)
      m:start(enemy)
    end
  end

  function enemy:go_hero()
    going_hero = true
    local m = sol.movement.create("target")
    m:set_speed(properties.faster_speed)
    m:set_ignore_obstacles(properties.ignore_obstacles)
    m:start(enemy)
    enemy:get_sprite():set_animation("walking")
  end
end

return behavior


----------------------------------
--
-- Add some basic methods to an enemy.
-- There is no passive behavior without an explicit start when learning this to an enemy.
--
-- Methods : General informations :
--           enemy:is_aligned(entity, thickness, [sprite])
--           enemy:is_near(entity, triggering_distance, [sprite])
--           enemy:is_entity_in_front(entity, [front_angle, [sprite]])
--           enemy:is_over_grounds(grounds, [x, [y]])
--           enemy:get_central_symmetry_position(x, y)
--           enemy:get_random_position_in_area(area)
--           enemy:get_obstacles_normal_angle(angle)
--           enemy:get_obstacles_bounce_angle(angle)
--
--           Movements and positioning :
--           enemy:start_straight_walking(angle, speed, [distance, [on_stopped_callback]])
--           enemy:start_target_walking(entity, speed)
--           enemy:start_jumping(duration, height, [angle, speed, [on_finished_callback]])
--           enemy:start_flying(take_off_duration, height, [on_finished_callback])
--           enemy:stop_flying(landing_duration, [on_finished_callback])
--           enemy:start_attracting(entity, speed, [moving_condition_callback])
--           enemy:stop_attracting([entity])
--           enemy:start_impulsion(angle, speed, acceleration, deceleration, [distance])
--           enemy:start_throwing(entity, duration, start_height, [maximum_height, [angle, speed, [on_finished_callback]]])
--           enemy:start_welding(entity, [x, [y, [layer]]])
--           enemy:start_leashed_by(entity, maximum_distance)
--           enemy:stop_leashed_by(entity)
--           enemy:start_pushed_back(entity, [speed, [duration, [sprite, [entity_sprite, [on_finished_callback]]]]])
--           enemy:start_pushing_back(entity, [speed, [duration, [sprite, [entity_sprite, [on_finished_callback]]]]])
--           enemy:start_shock(entity, [speed, [duration, [sprite, [entity_sprite, [on_finished_callback]]]]])
--
--           Effects and events :
--           enemy:start_death([dying_callback])
--           enemy:start_shadow([sprite_name, [animation_name, [x, [y]]]])
--           enemy:start_brief_effect(sprite_name, [animation_name, [x, [y, [maximum_duration, [on_finished_callback]]]]])
--           enemy:start_close_explosions(maximum_distance, duration, [explosion_sprite_name, [x, [y, [sound_id, [on_finished_callback]]]]])
--           enemy:start_sprite_explosions([sprites, [explosion_sprite_name, [x, [y, [sound_id, [on_finished_callback]]]]]])
--           enemy:stop_all()
--
-- Usage : 
-- local my_enemy = ...
-- local common_actions = require("enemies/lib/common_actions")
-- common_actions.learn(my_enemy)
--
----------------------------------

local common_actions = {}

function common_actions.learn(enemy)

  local audio_manager = require("scripts/audio_manager")

  local game = enemy:get_game()
  local map = enemy:get_map()
  local hero = map:get_hero()
  local trigonometric_functions = {math.cos, math.sin}
  local circle = 2.0 * math.pi
  local quarter = 0.5 * math.pi
  local eighth = 0.25 * math.pi

  local attracting_timers = {}
  local leashing_timers = {}
  local shadow = nil

  -- Return true if the entity is on the same row or column than the entity.
  function enemy:is_aligned(entity, thickness, sprite)

    local half_thickness = thickness * 0.5
    local entity_x, entity_y, entity_layer = entity:get_position()
    local x, y, layer = enemy:get_position()
    if sprite then
      local x_offset, y_offset = sprite:get_xy()
      x, y = x + x_offset, y + y_offset
    end

    return (math.abs(entity_x - x) < half_thickness or math.abs(entity_y - y) < half_thickness)
      and (layer == entity_layer or enemy:has_layer_independent_collisions())
  end

  -- Return true if the entity is closer to the enemy than triggering_distance
  function enemy:is_near(entity, triggering_distance, sprite)

    local entity_layer = entity:get_layer()
    local x, y, layer = enemy:get_position()
    if sprite then
      local x_offset, y_offset = sprite:get_xy()
      x, y = x + x_offset, y + y_offset
    end

    return entity:get_distance(x, y) < triggering_distance 
      and (layer == entity_layer or enemy:has_layer_independent_collisions())
  end

  -- Return true if the angle between the enemy sprite direction and the sprite to entity angle is less than or equals to the front_angle.
  function enemy:is_entity_in_front(entity, front_angle, sprite)

    front_angle = front_angle or quarter
    sprite = sprite or enemy:get_sprite()

    local x, y = enemy:get_position()
    local x_offset, y_offset = sprite:get_xy()
    local sprite_to_entity_angle = entity:get_angle(x + x_offset, y + y_offset) + math.pi

    -- Check the difference on the cosinus axis to easily consider angles from enemy to hero like pi and 3pi as the same.
    return math.cos(sprite:get_direction() * quarter - sprite_to_entity_angle) >= math.cos(front_angle / 2.0)
  end

  -- Return true if the four corners of the enemy are all over one of the given ground, or would be if the enemy would move by the given offset.
  function enemy:is_over_grounds(grounds, x, y)

    local enemy_x, enemy_y, width, height = enemy:get_bounding_box()
    local layer = enemy:get_layer()
    x = enemy_x + (x or 0)
    y = enemy_y + (y or 0)

    local function is_position_over_grounds(x, y)
      for _, ground in pairs(grounds) do
        if string.find(map:get_ground(x, y, layer), ground) then
          return true
        end
      end
      return false
    end

    return is_position_over_grounds(x, y)
        and is_position_over_grounds(x + width - 1, y)
        and is_position_over_grounds(x, y + height - 1)
        and is_position_over_grounds(x + width - 1, y + height - 1)
  end

  -- Return the central symmetry position over the given central point.
  function enemy:get_central_symmetry_position(x, y)

    local enemy_x, enemy_y, _ = enemy:get_position()
    return 2.0 * x - enemy_x, 2.0 * y - enemy_y
  end

  -- Get a random position in the given area, which may be a string or an entity.
  -- If the given area is a string the actual area is formed by all entities marked with the same area custom property, except enemies.
  function enemy:get_random_position_in_area(area)

    local sub_areas = {}
    local total_weight = 0

    local function add_area_entity(entity)
      local width, height = entity:get_size()
      local weight = width * height
      table.insert(sub_areas, {entity = entity, weight = weight})
      total_weight = total_weight + weight
    end

    -- Get all entites but enemies that have the same area custom properties if area is a string, else just add the given area entity to the list
    if type(area) == "string" then
      for entity in map:get_entities_in_region(enemy) do
        if entity:get_type() ~= "enemy" and entity:get_property("area") == area then
          add_area_entity(entity)
        end
      end
    else
      add_area_entity(area)
    end

    -- Choose a random point in all possible entities.
    local random_point = math.random(total_weight)
    for _, sub_area in pairs(sub_areas) do
      total_weight = total_weight - sub_area.weight
      if random_point > total_weight then
        local x, y, width, height = sub_area.entity:get_bounding_box()
        return math.random(x, x + width), math.random(y, y + height), sub_area.entity:get_layer()
      end
    end
  end

  -- Return the normal angle of close obstacles as a multiple of pi/4, or nil if none.
  function enemy:get_obstacles_normal_angle(angle)

    local collisions = {
      [0] = enemy:test_obstacles( 1,  0),
      [1] = enemy:test_obstacles( 1, -1),
      [2] = enemy:test_obstacles( 0, -1),
      [3] = enemy:test_obstacles(-1, -1),
      [4] = enemy:test_obstacles(-1,  0),
      [5] = enemy:test_obstacles(-1,  1),
      [6] = enemy:test_obstacles( 0,  1),
      [7] = enemy:test_obstacles( 1,  1)
    }

    -- Return the normal angle for the given direction8 if there is an obstacle on the direction, and not on the two surrounding ones if direction is a diagonal.
    local function check_normal_angle(direction8)
      return collisions[direction8] and (direction8 % 2 == 0 or not collisions[(direction8 - 1) % 8] and not collisions[(direction8 + 1) % 8])
    end

    -- Check for obstacles on each direction8 and return the normal angle if it is the correct one.
    for direction8 = 0, 7 do
      if math.cos(angle - direction8 * eighth) > math.cos(quarter) and check_normal_angle(direction8) then
        return (direction8 * eighth + math.pi) % circle
      end
    end
  end

  -- Return the angle after bouncing against close obstacles towards the given angle, or nil if no obstacles.
  function enemy:get_obstacles_bounce_angle(angle)

    local normal_angle = enemy:get_obstacles_normal_angle(angle)
    return (2.0 * normal_angle - angle + math.pi) % circle
  end

  -- Make the enemy straight move.
  function enemy:start_straight_walking(angle, speed, distance, on_stopped_callback)

    local movement = sol.movement.create("straight")
    movement:set_speed(speed)
    movement:set_max_distance(distance or 0)
    movement:set_angle(angle)
    movement:set_smooth(true)

    -- Stop the movement right now if the given distance is 0.
    if distance == 0 then
      if on_stopped_callback then
        on_stopped_callback()
      end
      return movement
    end
    movement:start(enemy)

    -- Consider the current move as stopped if finished or stuck.
    function movement:on_finished()
      if on_stopped_callback then
        on_stopped_callback()
      end
    end
    function movement:on_obstacle_reached()
      movement:stop()
      if on_stopped_callback then
        on_stopped_callback()
      end
    end

    -- Update the enemy sprites.
    for _, sprite in enemy:get_sprites() do
      if sprite:has_animation("walking") and sprite:get_animation() ~= "walking" then
        sprite:set_animation("walking")
      end
      sprite:set_direction(movement:get_direction4())
    end

    return movement
  end

  -- Make the enemy move to the entity.
  function enemy:start_target_walking(entity, speed)

    local movement = sol.movement.create("target")
    movement:set_speed(speed)
    movement:set_target(entity)
    movement:start(enemy)

    -- Update enemy sprites.
    local direction = movement:get_direction4()
    for _, sprite in enemy:get_sprites() do
      if sprite:has_animation("walking") and sprite:get_animation() ~= "walking" then
        sprite:set_animation("walking")
      end
      sprite:set_direction(direction)
    end
    function movement:on_position_changed()
      if movement:get_direction4() ~= direction then
        direction = movement:get_direction4()
        for _, sprite in enemy:get_sprites() do
          sprite:set_direction(direction)
        end
      end
    end

    return movement
  end

  -- Make the enemy start jumping.
  function enemy:start_jumping(duration, height, angle, speed, on_finished_callback)

    local movement

    -- Schedule an update of the sprite vertical offset by frame.
    local elapsed_time = 0
    sol.timer.start(enemy, 10, function()

      elapsed_time = elapsed_time + 10
      if elapsed_time < duration then
        for _, sprite in enemy:get_sprites() do
          sprite:set_xy(0, -math.sqrt(math.sin(elapsed_time / duration * math.pi)) * height)
        end
        return true
      else
        for _, sprite in enemy:get_sprites() do
          sprite:set_xy(0, 0)
        end
        if movement and enemy:get_movement() == movement then
          movement:stop()
        end

        -- Call events once jump finished.
        if on_finished_callback then
          on_finished_callback()
        end
      end
    end)
    enemy:set_obstacle_behavior("flying")

    -- Move the enemy on-floor if requested.
    if angle then
      movement = sol.movement.create("straight")
      movement:set_speed(speed)
      movement:set_angle(angle)
      movement:set_smooth(false)
      movement:start(enemy)
    
      return movement
    end
  end

  -- Make the enemy start flying.
  function enemy:start_flying(take_off_duration, height, on_finished_callback)

    -- Make enemy sprites start elevating.
    local is_finish_registered = false
    for _, sprite in enemy:get_sprites() do
      local movement = sol.movement.create("straight")
      movement:set_speed(height * 1000 / take_off_duration)
      movement:set_max_distance(height)
      movement:set_angle(math.pi * 0.5)
      movement:set_ignore_obstacles(true)
      movement:start(sprite)

      -- Call on_finished_callback() at the first movement finished.
      if not is_finish_registered then
        is_finish_registered = true
        function movement:on_finished()
          if on_finished_callback then
            on_finished_callback()
          end
        end
      end
    end
    enemy:set_obstacle_behavior("flying")
  end

  -- Make the enemy start landing. Works even if start_flying() was not called, as long as y sprites offset is negative.
  function enemy:stop_flying(landing_duration, on_finished_callback)

    -- Make the enemy sprites start landing.
    local is_finish_registered = false
    for _, sprite in enemy:get_sprites() do
      local _, height = sprite:get_xy()
      height = math.abs(height)

      local movement = sol.movement.create("straight")
      movement:set_speed(height * 1000 / landing_duration)
      movement:set_max_distance(height)
      movement:set_angle(-math.pi * 0.5)
      movement:set_ignore_obstacles(true)
      movement:start(sprite)

      -- Call on_finished_callback() at the first movement finished.
      if not is_finish_registered then
        is_finish_registered = true
        function movement:on_finished()
          if on_finished_callback then
            on_finished_callback()
          end
        end
        
        -- Call the on_finished callback right now if height is 0.
        if height == 0 then
          movement:stop()
          movement:on_finished()
          return
        end
      end
    end
  end

  -- Start attracting the given entity, negative speed possible.
  function enemy:start_attracting(entity, speed, moving_condition_callback)

    -- Don't use solarus movements to be able to start several movements at the same time.
    local move_ratio = speed > 0 and 1 or -1
    enemy:stop_attracting(entity)
    attracting_timers[entity] = {}

    local function attract_on_axis(axis)

      -- Clean the enemy if the entity was removed from outside.
      if not entity:exists() then
        enemy:stop_attracting(entity)
        return
      end

      local entity_position = {entity:get_position()}
      local enemy_position = {enemy:get_position()}
      local angle = math.atan2(entity_position[2] - enemy_position[2], enemy_position[1] - entity_position[1])
      
      local axis_move = {0, 0}
      local axis_move_delay = 10 -- Default timer delay if no move

      if not moving_condition_callback or moving_condition_callback() then

        -- Always move pixel by pixel.
        axis_move[axis] = math.max(-1, math.min(1, enemy_position[axis] - entity_position[axis])) * move_ratio
        if axis_move[axis] ~= 0 then

          -- Schedule the next move on this axis depending on the remaining distance and the speed value, avoiding too high and low timers.
          axis_move_delay = 1000.0 / math.max(1, math.min(1000, math.abs(speed * trigonometric_functions[axis](angle))))

          -- Move the entity.
          if not entity:test_obstacles(axis_move[1], axis_move[2]) then
            entity:set_position(entity_position[1] + axis_move[1], entity_position[2] + axis_move[2], entity_position[3])
          end
        end
      end

      return axis_move_delay
    end

    -- Start the pixel move schedule.
    for i = 1, 2 do
      local initial_delay = attract_on_axis(i)
      if initial_delay then
        attracting_timers[entity][i] = sol.timer.start(enemy, initial_delay, function()
          return attract_on_axis(i)
        end)
      end
    end
  end

  -- Stop looped timers related to the attractions.
  function enemy:stop_attracting(entity)

    for attracted_entity, timers in pairs(attracting_timers) do
      if timers and (not entity or entity == attracted_entity) then
        for i = 1, 2 do
          if timers[i] then
            timers[i]:stop()
          end
        end
      end
    end
  end

  -- Start a straight movement to the given angle for the given distance, applying a constant acceleration and deceleration (px/s²)
  -- Start decelerating when the distance is reached, and the movement finishes when ended normally without reaching an obstacle.
  -- The movement is stopped for both axis as soon as an obstacle is reached, no smooth movement possible for now nor angle and distance changes.
  function enemy:start_impulsion(angle, speed, acceleration, deceleration, distance)

    -- Don't use solarus movements to be able to start several movements at the same time.
    angle = angle % circle
    local movement = {}
    local timers = {}
    local step_axis_speeds = {}
    local maximum_axis_speeds = {math.abs(math.cos(angle) * speed), math.abs(math.sin(angle) * speed)}
    local current_acceleration = acceleration
    local distance_traveled = 0
    local ignore_obstacles = false
    step_axis_speeds[1] = (angle < quarter or angle > 3.0 * quarter) and 1 or (angle > quarter and angle < 3.0 * quarter) and -1 or 0
    step_axis_speeds[2] = (angle > 0 and angle < math.pi) and -1 or (angle > math.pi and angle < circle) and 1 or 0

    -- Call given event on the movement table.
    local function call_event(event)
      if event then
        event(movement)
      end
    end

    -- Schedule 1 pixel moves on each axis depending on the given acceleration.
    local function move_on_axis(axis)

      local axis_current_speed = 0
      return sol.timer.start(enemy, 10, function() -- Start a frame later to let the time to set settings from outside such as ignore obstacles.

        -- Move enemy if it wouldn't reach an obstacle.
        local x, y, layer = enemy:get_position()
        local step_move = {0, 0}
        step_move[axis] = step_axis_speeds[axis]
        if ignore_obstacles or not enemy:test_obstacles(step_move[1], step_move[2]) then
          enemy:set_position(x + step_move[1], y + step_move[2], layer)
          distance_traveled = distance_traveled + 1
          call_event(movement.on_position_changed)
        else
          local other_timer = timers[axis % 2 + 1]
          if other_timer then
            other_timer:stop()
          end
          call_event(movement.on_obstacle_reached)
          return false
        end

        -- Replace axis acceleration by the deceleration if the distance is reached, if any.
        if current_acceleration > 0 and distance and distance_traveled > distance then
          current_acceleration = -deceleration
          call_event(movement.on_decelerating)
        end

        -- Update speed between 0 and maximum speed (px/s) depending on acceleration.
        axis_current_speed = math.min(math.sqrt(math.max(0, math.pow(axis_current_speed, 2.0) + 2.0 * current_acceleration)), maximum_axis_speeds[axis])     

        -- Schedule the next pixel move and avoid too low timers when decelerating (less than 1px/s).
        if current_acceleration > 0 or axis_current_speed >= 1 then
          return 1000.0 / math.max(1, axis_current_speed)
        end

        -- Call on_finished() event when the last axis timers finished normally.
        timers[axis] = nil
        if not timers[axis % 2 + 1] then
          call_event(movement.on_finished)
        end
      end)
    end
    timers = {move_on_axis(1), move_on_axis(2)}

    -- TODO Reproduce generic build-in movement methods on the returned movement table.
    function movement:stop()
      for i = 1, 2 do
        if timers[i] then
          timers[i]:stop()
        end
      end
    end
    function movement:set_ignore_obstacles(ignore)
      ignore_obstacles = ignore or true
    end
    function movement:get_direction4()
      return math.floor((angle / circle * 8 + 1) % 8 / 2)
    end

    return movement
  end

  -- Throw the given entity.
  function enemy:start_throwing(entity, duration, start_height, maximum_height, angle, speed, on_finished_callback)

    local movement
    maximum_height = maximum_height or start_height

    -- Consider the throw as an already-started sinus function, depending on start_height.
    local elapsed_time = duration / (1 - math.asin(math.pow(start_height / maximum_height, 2)) / math.pi) - duration
    duration = duration + elapsed_time

    -- Schedule an update of the sprite vertical offset by frame.
    sol.timer.start(entity, 10, function()

      elapsed_time = elapsed_time + 10
      if elapsed_time < duration then
        for sprite_name, sprite in entity:get_sprites() do
          if sprite_name ~= "shadow" and sprite_name ~= "shadow_override" then -- Workaround : Don't change shadow height when the sprite is part of the entity.
            sprite:set_xy(0, -math.sqrt(math.sin(elapsed_time / duration * math.pi)) * maximum_height)
          end
        end
        return true
      else
        for _, sprite in entity:get_sprites() do
          sprite:set_xy(0, 0)
        end
        if movement and entity:get_movement() == movement then
          movement:stop()
        end

        -- Call events once jump finished.
        if on_finished_callback then
          on_finished_callback()
        end
      end
    end)

    -- Move the entity on-floor if requested.
    if angle then
      movement = sol.movement.create("straight")
      movement:set_speed(speed)
      movement:set_angle(angle)
      movement:set_smooth(false)
      movement:start(entity)
    
      return movement
    end
  end

  -- Make the entity welded to the enemy at the given offset position, and propagate main events and methods.
  function enemy:start_welding(entity, x, y, layer)

    x = x or 0
    y = y or 0
    layer = layer or 0

    local minimum_layer = enemy:get_map():get_min_layer()
    local maximum_layer = enemy:get_map():get_max_layer()
    enemy:register_event("on_update", function(enemy) -- Workaround : Replace the entity in on_update() instead of on_position_changed() to take care of hurt movements.
      local enemy_x, enemy_y, enemy_layer = enemy:get_position()
      entity:set_position(enemy_x + x, enemy_y + y, math.max(math.min(enemy_layer + layer, maximum_layer), minimum_layer))
    end)
    enemy:register_event("on_removed", function(enemy)
      if entity:exists() then
        entity:remove()
      end
    end)
    enemy:register_event("on_enabled", function(enemy)
      entity:set_enabled()
    end)
    enemy:register_event("on_disabled", function(enemy)
      entity:set_enabled(false)
    end)
    enemy:register_event("on_dead", function(enemy)
      if entity:exists() then
        entity:remove()
      end
    end)
    enemy:register_event("set_visible", function(enemy, visible)
      entity:set_visible(visible)
    end)
  end

  -- Set a maximum distance between the enemy and an entity, else replace the enemy near it.
  function enemy:start_leashed_by(entity, maximum_distance)

    leashing_timers[entity] = sol.timer.start(enemy, 10, function()
      
      if enemy:get_distance(entity) > maximum_distance then
        local enemy_x, enemy_y, layer = enemy:get_position()
        local hero_x, hero_y, _ = hero:get_position()
        local vX = enemy_x - hero_x
        local vY = enemy_y - hero_y
        local magV = math.sqrt(vX * vX + vY * vY)
        local x = hero_x + vX / magV * maximum_distance
        local y = hero_y + vY / magV * maximum_distance

        -- Move the entity.
        if not enemy:test_obstacles(x - enemy_x, y - enemy_y) then
          enemy:set_position(x, y, layer)
        end
      end

      return true
    end)
  end

  -- Stop the leashing attraction on the given entity
  function enemy:stop_leashed_by(entity)
    if leashing_timers[entity] then
      leashing_timers[entity]:stop()
      leashing_timers[entity] = nil
    end
  end

  -- Start pushing back the enemy, not using the built-in movement to not stop a possible running movement.
  function enemy:start_pushed_back(entity, speed, duration, sprite, entity_sprite, on_finished_callback)

    speed = speed or 150
    duration = duration or 100
    sprite = sprite or enemy:get_sprite()
    entity_sprite = entity_sprite or entity:get_sprite()

    -- Take the enemy and entity sprite positions as reference for the angle instead of the global enemy and entity positions.
    local enemy_x, enemy_y = enemy:get_position()
    local offset_x, offset_y = sprite:get_xy()
    local entity_x, entity_y = entity:get_position()
    local entity_offset_x, entity_offset_y = entity_sprite:get_xy()
    enemy_x = enemy_x + offset_x
    enemy_y = enemy_y + offset_y
    entity_x = entity_x + entity_offset_x
    entity_y = entity_y + entity_offset_y

    local angle = math.atan2(entity_y - enemy_y, enemy_x - entity_x)
    local step_axis = {math.max(-1, math.min(1, enemy_x - entity_x)), math.max(-1, math.min(1, enemy_y - entity_y))}

    local function attract_on_axis(axis)

      -- Clean the timer if the entity was removed from outside.
      if not entity:exists() then
        return
      end
      
      local axis_move = {0, 0}
      local axis_move_delay = 10 -- Default timer delay if no move
      enemy_x, enemy_y = enemy:get_position()

      -- Always move pixel by pixel.
      axis_move[axis] = step_axis[axis]
      if axis_move[axis] ~= 0 then

        -- Schedule the next move on this axis depending on the remaining distance and the speed value, avoiding too high and low timers.
        axis_move_delay = 1000.0 / math.max(1, math.min(1000, math.abs(speed * trigonometric_functions[axis](angle))))

        -- Move the entity.
        if not enemy:test_obstacles(axis_move[1], axis_move[2]) then
          enemy:set_position(enemy_x + axis_move[1], enemy_y + axis_move[2])
        end
      end

      return axis_move_delay
    end

    -- Start the pixel move schedule.
    local timers = {}
    for i = 1, 2 do
      local initial_delay = attract_on_axis(i)
      if initial_delay then
        timers[i] = sol.timer.start(enemy, initial_delay, function()
          return attract_on_axis(i)
        end)
      end
    end

    -- Schedule the end of the push.
    sol.timer.start(enemy, duration, function()
      for i = 1, 2 do
        if timers[i] then
          timers[i]:stop()
        end
      end
      if on_finished_callback then
        on_finished_callback()
      end
    end)
  end

  -- Start pushing the entity back, not using the built-in movement to not stop a possible running movement.
  function enemy:start_pushing_back(entity, speed, duration, sprite, entity_sprite, on_finished_callback)

    speed = speed or 150
    duration = duration or 100
    sprite = sprite or enemy:get_sprite()
    entity_sprite = entity_sprite or entity:get_sprite()

    -- Take the enemy and entity sprite positions as reference for the angle instead of the global enemy and entity positions.
    local enemy_x, enemy_y = enemy:get_position()
    local offset_x, offset_y = sprite:get_xy()
    local entity_x, entity_y = entity:get_position()
    local entity_offset_x, entity_offset_y = entity_sprite:get_xy()
    enemy_x = enemy_x + offset_x
    enemy_y = enemy_y + offset_y
    entity_x = entity_x + entity_offset_x
    entity_y = entity_y + entity_offset_y

    local angle = math.atan2(enemy_y - entity_y, entity_x - enemy_x)
    local step_axis = {math.max(-1, math.min(1, entity_x - enemy_x)), math.max(-1, math.min(1, entity_y - enemy_y))}

    -- Returns whether an entity would overlap a teletransporter if moved of some offset.
    local function overlaps_teletransporter(entity, offset_x, offset_y)
      local map = entity:get_map()
      local x, y, width, height = entity:get_bounding_box()
      for other_entity in map:get_entities_in_rectangle(x + offset_x, y + offset_y, width, height) do
        if other_entity:get_type() == "teletransporter" and other_entity:get_layer() == entity:get_layer() then
          return true
        end
      end
    end

    local function attract_on_axis(axis)

      -- Clean the timer if the entity was removed from outside.
      if not entity:exists() then
        return
      end
      
      local axis_move = {0, 0}
      local axis_move_delay = 10 -- Default timer delay if no move
      entity_x, entity_y = entity:get_position()

      -- Always move pixel by pixel.
      axis_move[axis] = step_axis[axis]
      if axis_move[axis] ~= 0 then

        -- Schedule the next move on this axis depending on the remaining distance and the speed value, avoiding too high and low timers.
        axis_move_delay = 1000.0 / math.max(1, math.min(1000, math.abs(speed * trigonometric_functions[axis](angle))))

        -- Move the entity.
        if not entity:test_obstacles(axis_move[1], axis_move[2]) and
            not overlaps_teletransporter(entity, axis_move[1], axis_move[2]) then
          -- We have to avoid obstacles and teletransporters explicitly because
          -- we directly call entity:set_position() instead of using a movement.
          entity:set_position(entity_x + axis_move[1], entity_y + axis_move[2])
        end
      end

      return axis_move_delay
    end

    -- Start the pixel move schedule.
    local timers = {}
    for i = 1, 2 do
      local initial_delay = attract_on_axis(i)
      if initial_delay then
        timers[i] = sol.timer.start(entity, initial_delay, function()
          return attract_on_axis(i)
        end)
      end
    end

    -- Schedule the end of the push.
    sol.timer.start(entity, duration, function()
      for i = 1, 2 do
        if timers[i] then
          timers[i]:stop()
        end
      end
      if on_finished_callback then
        on_finished_callback()
      end
    end)
  end

  -- Start pushing both enemy and entity back with an impact effect.
  function enemy:start_shock(entity, speed, duration, sprite, entity_sprite, on_finished_callback)

    local x, y, _ = enemy:get_position()
    local hero_x, hero_y, _ = hero:get_position()
    enemy:start_pushed_back(hero, speed, duration, sprite, entity_sprite)
    enemy:start_pushing_back(hero, speed, duration, sprite, entity_sprite, function()
      if on_finished_callback then
        on_finished_callback()
      end
    end)
    enemy:start_brief_effect("entities/effects/impact_projectile", "default", (hero_x - x) / 2, (hero_y - y) / 2)
  end

  -- Make the enemy die as described in the given dying_callback, or silently and without animation if nil.
  -- Stop all actions and prevent interactions when the function starts, then run the dying_callback which will finish_death() manually when needed.
  -- Additionnal helper functions are accessible from the callback to describe the death :
  --   set_treasure_falling_height(height) -> Set the treasure falling height in pixel, which is 8 by default.
  --   finish_death() -> Start all behaviors related to the enemy actual death, basically treasure drop, savegame and removal.
  function enemy:start_death(dying_callback)

    local dying_helpers = {}
    local treasure_falling_height = 8
    enemy.is_hurt_silently = true -- Workaround : Don't play generic sounds added by enemy meta script.

    -- Stop all running actions and call on_dying() event.
    enemy:stop_all()
    if enemy.on_dying then
      enemy:on_dying()
    end

    -- Helper function to set the treasure falling height in pixel.
    function dying_helpers.set_treasure_falling_height(height)
      treasure_falling_height = height
    end

    -- Helper function to start all behaviors related to the enemy actual death, basically treasure drop, savegame and removal.
    function dying_helpers.finish_death()

      -- Make a possible treasure appear.
      local treasure_name, treasure_variant, treasure_savegame = enemy:get_treasure()
      if treasure_name then
        local x, y, layer = enemy:get_position()
        local pickable = map:create_pickable({
          x = x,
          y = y,
          layer = layer,
          treasure_name = treasure_name,
          treasure_variant = treasure_variant,
          treasure_savegame_variable = treasure_savegame
        })

        -- Replace the built-in falling by a throw from the given height.
        if pickable and pickable:exists() then -- If the pickable was not immediately removed from the on_created() event.
          if pickable:get_treasure():get_name() ~= "fairy" then -- Workaround: No way to set no built-in falling movement nor detect it from a movement initiated in on_created. Don't stop the movement for some items.
            pickable:stop_movement()
            enemy:start_throwing(pickable, 450 + treasure_falling_height * 6, treasure_falling_height, treasure_falling_height + 16) -- TODO Find a better way to set a duration.
          end
        end
      end

      -- TODO Handle savegame if any.

      -- Actual removal and on_dead() event call.
      enemy:remove()
      if enemy.on_dead then
        enemy:on_dead()
      end
    end

    -- Die as described in the dying_callback if given, else kill the enemy without any animation. 
    if dying_callback then
      setmetatable(dying_helpers, {__index=getfenv(2)})
      setfenv(dying_callback, dying_helpers)
      dying_callback()
    else
      dying_helpers.finish_death()
    end
  end

  -- Add a shadow below the enemy.
  function enemy:start_shadow(sprite_name, animation_name, x, y)

    if not shadow then
      local enemy_x, enemy_y, enemy_layer = enemy:get_position()
      shadow = map:create_custom_entity({
        direction = 0,
        x = enemy_x + (x or 0),
        y = enemy_y + (y or 0),
        layer = enemy_layer,
        width = 8,
        height = 8,
        sprite = sprite_name or "entities/shadows/shadow"
      })
      shadow:set_weight(-1)
      enemy:start_welding(shadow, x, y)

      if animation_name then
        shadow:get_sprite():set_animation(animation_name)
      end
      shadow:set_traversable_by(true)
      shadow:set_drawn_in_y_order(false) -- Display the shadow as a flat entity.
      shadow:bring_to_front() -- Display it over other flat entities, such as grass.
      
      -- Always display the shadow on the lowest possible layer.
      function shadow:on_position_changed(x, y, layer)
        for ground_layer = enemy:get_layer(), map:get_min_layer(), -1 do
          if map:get_ground(x, y, ground_layer) ~= "empty" then
            if shadow:get_layer() ~= ground_layer then
              shadow:set_layer(ground_layer)
            end
            break
          end
        end
      end
    end

    -- Make the shadow disappear when the enemy became invisible on dying.
    enemy:register_event("on_dying", function(enemy)
      sol.timer.start(shadow, 300, function() -- No event when the enemy became invisible, hardcode a timer.
        if shadow:exists() then
          shadow:remove()
        end
      end)
    end)

    return shadow
  end

  -- Start a standalone sprite animation on the enemy position, that will be removed once finished or maximum_duration reached if given.
  function enemy:start_brief_effect(sprite_name, animation_name, x, y, maximum_duration, on_finished_callback)

    local enemy_x, enemy_y, enemy_layer = enemy:get_position()
    local entity = map:create_custom_entity({
        sprite = sprite_name,
        x = enemy_x + (x or 0),
        y = enemy_y + (y or 0),
        layer = enemy_layer,
        width = 80,
        height = 32,
        direction = 0
    })
    entity:set_drawn_in_y_order()

    -- Remove the entity once animation finished or max_duration reached.
    local function on_finished()
      if on_finished_callback then
        on_finished_callback()
      end
      if entity:exists() then
        entity:remove()
      end
    end
    local sprite = entity:get_sprite()
    sprite:set_animation(animation_name or sprite:get_animation(), function()
      on_finished()
    end)
    if maximum_duration then
      sol.timer.start(entity, maximum_duration, function()
        on_finished()
      end)
    end

    return entity
  end

  -- Start a new explosion placed randomly around the entity coordinates each time the previous one finished, until duration reached.
  function enemy:start_close_explosions(maximum_distance, duration, explosion_sprite_name, x, y, sound_id, on_finished_callback)

    explosion_sprite_name = explosion_sprite_name or "entities/explosion_boss"
    x = x or 0
    y = y or 0

    local elapsed_time = 0
    local function start_close_explosion()
      local random_distance = math.random() * maximum_distance
      local random_angle = math.random(circle)
      local random_x = math.cos(random_angle) * random_distance
      local random_y = math.sin(random_angle) * random_distance
      
      local explosion = enemy:start_brief_effect(explosion_sprite_name, nil, random_x + x, random_y + y, nil, function()
        if elapsed_time < duration then
          start_close_explosion()
        else
          if on_finished_callback then
            on_finished_callback()
          end
        end
      end)
      local sprite = explosion:get_sprite()
      audio_manager:play_sound(sound_id)
      elapsed_time = elapsed_time + sprite:get_frame_delay() * sprite:get_num_frames()
    end
    start_close_explosion()
    enemy:set_drawn_in_y_order(false) -- Display as a flat entity to draw explosions over it.
  end

  -- Make the given enemy sprites explode one after the other in the given order, and remove exploded sprite.
  function enemy:start_sprite_explosions(sprites, explosion_sprite_name, x, y, sound_id, on_finished_callback)

    sprites = sprites or enemy:get_sprites()
    explosion_sprite_name = explosion_sprite_name or "entities/explosion_boss"
    x = x or 0
    y = y or 0

    local function start_sprite_explosion(index)
      local sprite = sprites[index]
      local sprite_x, sprite_y = sprite:get_xy()
      local explosion = enemy:start_brief_effect(explosion_sprite_name, nil, sprite_x + x, sprite_y + y, nil, function()
        if index < #sprites then
          start_sprite_explosion(index + 1)
        else
          if on_finished_callback then
            on_finished_callback()
          end
        end
      end)
      enemy:remove_sprite(sprite)
      audio_manager:play_sound(sound_id)
    end
    start_sprite_explosion(1)
    enemy:set_drawn_in_y_order(false) -- Display as a flat entity to draw explosions over it.
  end

  -- Stop all running actions and prevent interactions with other entities.
  function enemy:stop_all()

    sol.timer.stop_all(enemy)
    enemy:stop_movement()
    enemy:set_can_attack(false)
    enemy:set_invincible()
  end
end

return common_actions
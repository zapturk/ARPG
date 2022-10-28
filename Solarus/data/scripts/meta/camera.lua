-- Provides additional camera features for this quest.

-- Variables
local camera_meta = sol.main.get_metatable("camera")
local is_shaking = false

function camera_meta:is_shaking()
  return is_shaking
end

function camera_meta:shake(config, callback)

  local shaking_count_max = config ~= nil and config.count or 9
  local amplitude = config ~= nil and config.amplitude or 4
  local speed = config ~= nil and config.speed or 60

  local camera = self
  local map = camera:get_map()
  local hero = map:get_hero()

  local shaking_to_right = true
  local shaking_count = 0

  local function shake_step()

    local movement = sol.movement.create("straight")
    movement:set_speed(speed)
    movement:set_smooth(false)
    movement:set_ignore_obstacles(true)

    -- Determine direction.
    if shaking_to_right then
      movement:set_angle(0)  -- Right.
    else
      movement:set_angle(math.pi)  -- Left.
    end

    -- Max distance.
    movement:set_max_distance(amplitude)

    -- Inverse direction for next time.
    shaking_to_right = not shaking_to_right
    shaking_count = shaking_count + 1

    -- Launch the movement and repeat if needed.
    is_shaking = true
    movement:start(camera, function()

        -- Repeat shaking until the count_max is reached.
        if shaking_count <= shaking_count_max then
          -- Repeat shaking.
          shake_step()
        else
          -- Finished.
          print("Finished")
          is_shaking = false
          camera:start_tracking(hero)
          if callback ~= nil then
            callback()
          end
        end
      end)
  end

  shake_step()

end


--shake while following an entity
function camera_meta:dynamic_shake(config, callback)

  local shaking_count_max = config ~= nil and config.count or 9
  local amplitude = config ~= nil and config.amplitude or 8
  local entity_to_track = config ~= nil and config.entity or self:get_map():get_hero()

  local camera = self
  local map = camera:get_map()

  local shaking_to_right = true
  local shaking_count = 0
  local offset_x=0
  local offset_y=0

  local camera_width, camera_height=camera:get_size()

  local function clamp(val, min, max)
    return math.max(min, math.min(val, max))
  end

  local function get_region_bounding_box(map,x,y)
    --By default, make the region bounding box match the map's
    local boundary_xmin=0
    local boundary_ymin=0
    local boundary_xmax, boundary_ymax=map:get_size()
    -- Then, shrink bounding box to actual region size by comparing with the separators; if any.
    for e in map:get_entities_in_region(x,y) do
      if e:get_type()=="separator" then
        local separator_x,separator_y, separator_w, separator_h=e:get_bounding_box()
        if separator_w>separator_h then --Horizontal separator
          if y>separator_y then
            boundary_ymin=math.max(boundary_ymin, separator_y+8)
          else
            boundary_ymax=math.min(boundary_ymax, separator_y+8)  
          end
        else
          if x>separator_x then
            boundary_xmin=math.max(boundary_xmin, separator_x+8)
          else
            boundary_xmax=math.min(boundary_xmax, separator_x+8)
          end
        end
      end
    end
    return boundary_xmin, boundary_ymin, boundary_xmax, boundary_ymax
  end
  local region_xmin, region_ymin, region_xmax, region_ymax=get_region_bounding_box(map, entity_to_track:get_position())

  local function shake_step()

    -- Determine the shifting offset (maybe shift according to a given direction in the future?)
    if shaking_to_right then
      offset_x = amplitude/2 -- Right.
      offset_y = amplitude/2 
    else
      offset_x = -amplitude/2 -- Left.
      offset_y = -amplitude/2
    end

    local entity_x, entity_y, entity_w, entity_h=entity_to_track:get_bounding_box()

    camera:set_position(clamp(entity_x+entity_w/2-camera_width/2+offset_x, region_xmin+offset_x, region_xmax-camera_width+offset_y),
                        clamp(entity_y+entity_w/2-camera_height/2+offset_x, region_ymin+offset_y, region_ymax-camera_height+offset_y))

    -- Inverse direction for next time.
    shaking_to_right = not shaking_to_right
    shaking_count = shaking_count + 1

    -- Repeat shaking until the count_max is reached.
    if shaking_count <= shaking_count_max then
      -- Repeat shaking.
      return true
    else
      -- Finished.
      is_shaking = false
      camera:start_tracking(entity_to_track)
      if callback ~= nil then
        callback()
      end
    end
--      end)
  end
  sol.timer.start(camera, 10, shake_step)
  is_shaking = true
end

return true

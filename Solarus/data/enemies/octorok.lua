-- Lua script of enemy octorok.
-- This script is executed every time an enemy with this model is created.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation for the full specification
-- of types, events and methods:
-- http://www.solarus-games.org/doc/latest

local enemy = ...
require("scripts/multi_events")
require("enemies/lib/common_actions").learn(enemy)
require("enemies/lib/weapons").learn(enemy)
local game = enemy:get_game()
local map = enemy:get_map()
local hero = map:get_hero()
local sprite = enemy:create_sprite("enemies/" .. enemy:get_breed())
local quarter = math.pi * 0.5

-- Configuration variables.
local walking_angles = {0, quarter, 2.0 * quarter, 3.0 * quarter}
local walking_speed = 48
local walking_minimum_distance = 16
local walking_maximum_distance = 32
local waiting_duration = 800
local throwing_duration = 200

local projectile_breed = "stone"
local projectile_offset = {{0, -8}, {0, -8}, {0, -8}, {0, -8}}


function enemy:on_created()
  enemy:set_life(1)
end

function enemy:on_restarted()
   -- States.
  enemy:set_can_attack(true)
  enemy:set_damage(1)
  enemy:start_walking()
end

-- Start the enemy movement.
function enemy:start_walking()
  local direction = math.random(4)
  enemy:start_straight_walking(walking_angles[direction], walking_speed, math.random(walking_minimum_distance, walking_maximum_distance), function() 
    sprite:set_animation("immobilized")
    sol.timer.start(enemy, waiting_duration, function()

      -- Throw a stone if the hero is on the direction the enemy is looking at.
      if enemy:get_direction4_to(hero) == sprite:get_direction() then
        enemy:throw_projectile(projectile_breed, throwing_duration, projectile_offset[direction][1], projectile_offset[direction][2], function()
        --  audio_manager:play_entity_sound(enemy, "enemies/octorok_firing")
          enemy:start_walking()
        end)
      else
        enemy:start_walking()
      end
    end)
  end)
end

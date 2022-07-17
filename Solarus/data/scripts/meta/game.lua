local game_meta = sol.main.get_metatable("game")

local function map_callback(game, map)
  print("GAME CALLBACK")
  local camera = map:get_camera()
  camera:set_size(CAMERA_W,CAMERA_H)
  camera:set_position_on_screen(0, 16)
  
--   if map.obscurity then
--     map:set_obscurity(map.obscurity)
--   --game.obscurity_shader:set_uniform("amount", 3)
--   end
--   --camera:get_surface():set_shader(game.chroma_shader)
--   local hero = map:get_hero()
--   hero:save_solid_ground()
--   hero:reset_walking_speed()

--   if (hero:get_sprite():get_shader() and not hero:get_sprite():get_shader().persistent) then
--     hero:get_sprite():set_shader(nil)
--   end
end

game_meta:register_event("on_map_changed", map_callback)
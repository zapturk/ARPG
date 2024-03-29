local background_builder = {}

local background_img = sol.surface.create("hud/background.png")
-- background_img:fill_color{242,224,209}

function background_builder:new(game,config)
  local background = {name = "HUD Background"}
  function background:on_draw(dst_surface)
    background_img:draw(dst_surface,config.x,config.y)
  end
  
  return background
end

return background_builder

local text_fx_helper = require("scripts/text_fx_helper")
local language_manager = require("scripts/language_manager")

local parchment = {}

------------------------------ Specific functions -----------------------------

-- Shows a parchment unrolling itself to show text.
--  context:      The context for the menu.
--  type:         The style for the menu ("boss" or "default").
--  position:     The position on the screen ("top", "bottom")
--  delay:        Delay after which the menu will close (use 0 to keep it open).
--  text_line_1:  First line of text (will be displayed with border and shadow).
--  text_line_2:  Second line of text (will be displayed in smaller font).
--  on_opened_callback: Called when menu is opened.
--  on_closing_callback: Called when menu is about to close.
--  on_closed_callback: Called when menu is closed.
function parchment:show(context, type, position, delay, text_line_1, text_line_2, on_opened_callback, on_closing_callback, on_closed_callback)
  
  if parchment.started then
    return
  end

  parchment.type = type or "default"
  parchment.position = position or "center"
  parchment.delay = 3000
  if delay ~= nil and sol.main.get_type(delay) == "number" then
    parchment.delay = delay
  end

  parchment.text_line_1 = text_line_1
  parchment.text_line_2 = text_line_2
  parchment.on_opened_callback = on_opened_callback
  parchment.on_closing_callback = on_closing_callback
  parchment.on_closed_callback = on_closed_callback

  parchment:initialize()

  -- Show the menu.
  sol.menu.start(context, parchment, true)
  parchment.started = true
end

-- Hides the menu.
function parchment:hide(animate)

  if not sol.menu.is_started(parchment) then
    return
  end

  if animate ~= nil and not animate then
    sol.menu.stop(self)
    return
  end

  if parchment.finished then
    return
  end
  parchment.finished = true

  parchment.state = "closing"
  
  if parchment.on_closing_callback ~= nil then
    parchment.on_closing_callback()
  end

  parchment.parchment_shadow_sprite:fade_out(10)

  local current_animation = parchment.parchment_sprite:get_animation()
  if current_animation == "opening" or  current_animation == "open" then
    
    -- Get start frame.
    local start_frame = 0

    if current_animation == "opening" then
      local current_frame = parchment.parchment_sprite:get_frame()
      local closing_frame_count = parchment.parchment_sprite:get_num_frames("closing", 0)
      start_frame = closing_frame_count - 1 - current_frame
    end
    
    -- Start at correct frame.
    parchment.parchment_shadow_sprite:set_animation("closing")
    parchment.parchment_shadow_sprite:set_paused(true)
    parchment.parchment_shadow_sprite:set_frame(start_frame)

    parchment.parchment_sprite:set_animation("closing")
    parchment.parchment_sprite:set_paused(true)
    parchment.parchment_sprite:set_frame(start_frame)

    -- Unfortunately we have to used register_event because there is no function
    -- sprite:set_animation(animation_name, frame, [next_action])
    parchment.parchment_sprite:register_event("on_animation_finished", function(sprite, animation)      
      if animation == "closing" then
        parchment.state = "fading_out"
        parchment.parchment_sprite:set_animation("closed")
        parchment.parchment_shadow_sprite:set_animation("closed")
        -- Fade-out the menu, then close it.
        parchment.parchment_sprite:fade_out(10, function()
          sol.menu.stop(self)
        end)
      end
    end)

    -- Go!
    parchment.parchment_shadow_sprite:set_paused(false)
    parchment.parchment_sprite:set_paused(false)

  elseif current_animation == "closed" then
    -- Fade-out the menu, then close it.
    parchment.parchment_sprite:fade_out(10, function()
      sol.menu.stop(self)
    end)
  end
end

-- Prepare all sprites and surfaces.
function parchment:initialize()

  parchment.started = false
  parchment.finished = false

  -- Needs to be configured based on the sprites used.
  local mask_start_frame = 1  -- Frame after which text begins to be visible.
  local mask_origin_px = 8    -- First mask width when the text is visible.
  local mask_delta_px = 16    -- Visible width added for every frame.

  -- Create parchment sprite.
  local text_line_1_color = { 255, 255, 255 }
  local text_line_1_stroke_color = nil
  local text_line_1_shadow_color = nil
  local text_line_2_color = nil
  if parchment.type == "boss" then
    text_line_1_stroke_color = {124, 57, 30}
    text_line_1_shadow_color = {46, 8, 0}
    text_line_2_color = {124, 57, 30}
    parchment.parchment_sprite = sol.sprite.create("menus/parchment/parchment_boss")
  else
    text_line_1_stroke_color = {133, 96, 30}
    text_line_1_shadow_color = {85, 20, 0}
    text_line_2_color = {158, 117, 70}
    parchment.parchment_sprite = sol.sprite.create("menus/parchment/parchment_default")
  end
  parchment.parchment_sprite:set_ignore_suspend(true)

  -- Shadow
  parchment.parchment_shadow_sprite = sol.sprite.create("menus/parchment/parchment_shadow")
  parchment.parchment_shadow_sprite:set_ignore_suspend(true)

  -- Create texts surface
  parchment.surface_w, parchment.surface_h = parchment.parchment_sprite:get_size()
  parchment.text_lines_surface = sol.surface.create(parchment.surface_w, parchment.surface_h)

  -- Create and draw first text line.
  local menu_font, menu_font_size = language_manager:get_menu_font()
  local text_line_surface_1 = sol.text_surface.create{
    horizontal_alignment = "center",
    vertical_alignment = "middle",
    text = parchment.text_line_1,
    font = menu_font,
    font_size = menu_font_size,
    color = text_line_1_color,
  }
  text_line_surface_1:set_xy(parchment.surface_w / 2, 13)
  text_fx_helper:draw_text_with_stroke_and_shadow(parchment.text_lines_surface, text_line_surface_1, text_line_1_stroke_color, text_line_1_shadow_color)

  -- Create and draw second text line.
  local text_line_surface_2 = sol.text_surface.create{
    horizontal_alignment = "center",
    vertical_alignment = "middle",
    text = parchment.text_line_2,
    font = "04b03",
    font_size = 8,
    color = text_line_2_color,
  }
  text_line_surface_2:draw(parchment.text_lines_surface, parchment.surface_w / 2, parchment.surface_h - 6)

  parchment.state = "fading_out"

  parchment.visible_text_surface = sol.surface.create(parchment.surface_w, parchment.surface_h)
  
  -- Draw only what is allowed by the mask.
  parchment.parchment_sprite:register_event("on_frame_changed", function(sprite, animation, frame)
    if parchment.state == "closing" then
      parchment.visible_text_surface:clear()
      local mask_w = parchment.surface_w - mask_origin_px - (frame + mask_start_frame) * mask_delta_px
      local mask_h = parchment.surface_h      
      local mask_x = (parchment.surface_w - mask_w) / 2
      local mask_y = 0
      parchment.text_lines_surface:draw_region(mask_x, mask_y, mask_w, mask_h , parchment.visible_text_surface, (parchment.surface_w - mask_w) / 2, (parchment.surface_h - mask_h) / 2)

    elseif frame > mask_start_frame and parchment.state == "opening" then
      parchment.visible_text_surface:clear()
      local mask_w = mask_origin_px + (frame - mask_start_frame) * mask_delta_px
      local mask_h = parchment.surface_h
      local mask_x = (parchment.surface_w - mask_w) / 2
      local mask_y = 0
      parchment.text_lines_surface:draw_region(mask_x, mask_y, mask_w, mask_h , parchment.visible_text_surface, (parchment.surface_w - mask_w) / 2, (parchment.surface_h - mask_h) / 2)
    end
  end)
end

function parchment:start()
  -- Pause the animation while fading in.
  parchment.parchment_sprite:set_animation("closed")
  parchment.parchment_shadow_sprite:set_animation("closed")
  parchment.parchment_sprite:set_opacity(0)
  parchment.parchment_shadow_sprite:set_opacity(0)

  if parchment.finished then
    return
  end
  
  parchment.parchment_sprite:fade_in(5)
  
  -- Launch animation.
  parchment.state = "opening"
  parchment.parchment_shadow_sprite:set_animation("opening")
  parchment.parchment_sprite:set_animation("opening", function()

    if parchment.finished then
      return
    end

    parchment.state = "open"
    parchment.parchment_shadow_sprite:set_animation("open")
    parchment.parchment_sprite:set_animation("open")

    parchment.parchment_shadow_sprite:fade_in(10)

    if parchment.delay <= 0 then
      if parchment.on_opened_callback ~= nil then
        parchment.on_opened_callback()

        -- Prevent it to be called two times.
        parchment.on_opened_callback = nil
      end
    else
      if parchment.finished then
        return
      end
      
      -- Start the timer.
      sol.timer.start(parchment, parchment.delay, function()
        -- After the delay, close the parchment.
        parchment:hide(true)
      end)
    end
  end)
end

------------------------------- Menus functions -------------------------------

function parchment:on_started()

  parchment:start()
end

function parchment:on_draw(dst_surface)

  local dst_w, dst_h = dst_surface:get_size()
  local x = (dst_w - parchment.surface_w) / 2
  local y = 0
  local margin = 16
  if parchment.position == "top" then
    y = margin
  elseif parchment.position == "bottom" then
    y = dst_h - parchment.surface_h - margin
  elseif parchment.position == "center" then
    y = (dst_h - parchment.surface_h) / 2
  end
  
  -- Shadow
  if parchment.state ~= "closed" and parchment.state ~= "fading_out" then
    parchment.parchment_shadow_sprite:draw(dst_surface, x, y + 2)
  end
  
  -- Parchment
  parchment.parchment_sprite:draw(dst_surface, x, y)

  -- Text
  if parchment.state ~= "fading_out" then
    parchment.visible_text_surface:draw(dst_surface, x, y)
  end
end

function parchment:on_finished()
  parchment.started = false
  parchment.finished = true

  if parchment.delay <=0 and parchment.on_closed_callback ~= nil then
    parchment.on_closed_callback()
  end
end

return parchment

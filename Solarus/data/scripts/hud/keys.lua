local keys_builder = {}

local keys_icon_img = sol.surface.create("hud/small_key_icon.png")

function keys_builder:new(game, config)
  local keys = { name = "HUD Keys" }

  local digits_text = sol.text_surface.create({
    font = "8_bit OOS",
    horizontal_alignment = "left",
    vertical_alignment = "top",
    set_color = "0,0,0",
  })

  local keys_displayed = game:get_num_small_keys() or 0

  local dst_x, dst_y = config.x, config.y

  function keys:on_draw(dst_surface)

    local x, y = dst_x, dst_y
    local width, height = dst_surface:get_size()
    if x < 0 then
      x = width + x
    end
    if y < 0 then
      y = height + y
    end

    keys_icon_img:draw(dst_surface,x, y)
    digits_text:draw(dst_surface, x+10 ,y+1)
  end

  local function check()
    local need_rebuild = false
    local keys = game:get_num_small_keys() or 0

    if keys ~= keys_displayed then
      need_rebuild = true
      if keys_displayed < keys then
        keys_displayed = keys_displayed + 1
      else
        keys_displayed = keys_displayed - 1
      end
    end

    if digits_text:get_text() == "" then
      need_rebuild = true
    end

    -- Update the text if something has changed.
    if need_rebuild then
      digits_text:set_text(string.format("%01d", keys_displayed))
      digits_text:set_color({0,0,0})
      digits_text:set_font_size(10)
    end

    print(game:get_map().small_keys_savegame_variable)
  end

  check()
  sol.timer.start(game, 40, check)

  return keys
end

return keys_builder

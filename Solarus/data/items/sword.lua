local item = ...

function item:on_created()

  self:set_savegame_variable("possession_sword")
  self:set_sound_when_picked(nil)
  self:set_sound_when_brandished("treasure")
end

function item:on_variant_changed(variant)
  -- The possession state of the sword determines the built-in ability "sword".
  local hero=item:get_game():get_hero()

 --Cleanup old sword sprite, if any
  if hero:get_sprite("sword_override") then
    hero:remove_sprite(hero:get_sprite("sword_override"))
  end

  if hero:get_sprite("sword_stars_override") then
    hero:remove_sprite(hero:get_sprite("sword_stars_override"))
  end

  --Set new sprite
  if variant > 0 then
    hero:create_sprite("hero/sword"..variant, "sword_override"):stop_animation()
    hero:create_sprite("hero/sword_stars"..variant, "sword_stars_override"):stop_animation()
    self:get_game():set_ability("sword", variant)
  end
end



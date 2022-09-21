-- Defines the elements to put in the HUD
-- and their position on the game screen.

-- You can edit this file to add, remove or move some elements of the HUD.

-- Each HUD element script must provide a method new()
-- that creates the element as a menu.
-- See for example scripts/hud/hearts.

-- Negative x or y coordinates mean to measure from the right or bottom
-- of the screen, respectively.

local hud_config = {
  -- background
  {
    menu_script = "scripts/hud/background",
    x = 0,
    y = 0,
   }, 

  -- Hearts meter.
  {
    menu_script = "scripts/hud/hearts",
    x = -42,
    y = 0,
  },

  -- Key counter.
  {
    menu_script = "scripts/hud/keys",
    x = 85,
    y = 0,
  },

  -- Money counter.
  {
    menu_script = "scripts/hud/money",
    x = 85,
    y = 8,
  },

  -- Item assigned to slot 1.
  {
    menu_script = "scripts/hud/item",
    x = 6,
    y = 1,
    slot = 1,  -- Item slot (1 or 2).
  },

  -- Item assgned to slot 2
  {
    menu_script = "scripts/hud/item",
    x = 32,
    y = 1,
    slot = 2
  },

}

return hud_config

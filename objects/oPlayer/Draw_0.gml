// Draw Shadow under player
draw_sprite(sShadow, 0, floor(x), floor(y));

// Draw the currnet sprite for the player
draw_sprite_ext(
	sprite_index,
	image_index,
	floor(x),
	floor(y - z),
	image_xscale,
	image_yscale,
	image_angle,
	image_blend,
	image_alpha
)

//draw_sprite(sHeroCM, 0, floor(x), floor(y - z));
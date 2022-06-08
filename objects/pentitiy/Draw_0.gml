// if the entity has a shadow draw it
if(entityShadow){
	draw_sprite(sShadow, 0, floor(x), floor(y));
}

if(flash != 0){
	shader_set(shWhiteFlash);
	shader_set_uniform_f(uFlash, flash);
}

// Draw the sprite
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

if(shader_current() != -1){
	shader_reset();
}

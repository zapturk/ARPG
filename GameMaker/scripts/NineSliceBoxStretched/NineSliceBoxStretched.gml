function NineSliceBoxStretched(sprite, x1, y1, x2, y2, imgIndex){
	var size = sprite_get_width(sprite) / 3;
	var w = x2 - x1;
	var h = y2 - y1;
	
	var xScale = w - (size * 2);
	var yScale = h - (size * 2);
	
	// middle
	draw_sprite_part_ext(sprite, imgIndex, size, size, 1, 1, x1 + size, y1 + size, xScale, yScale, c_white, 1);
	
	// Corners
	// top left
	draw_sprite_part(sprite, imgIndex, 0, 0, size, size, x1, y1);
	// top right
	draw_sprite_part(sprite, imgIndex, size * 2, 0, size, size, x1 + w - size, y1);
	// bottom left
	draw_sprite_part(sprite, imgIndex, 0, size * 2, size, size, x1, y1 + h - size);
	// bottom left
	draw_sprite_part(sprite, imgIndex, size * 2, size * 2, size, size, (x1 + w - size), (y1 + h - size));
	
	// Edge
	// left
	draw_sprite_part_ext(sprite, imgIndex, 0, size, size, 1, x1, y1 + size, 1, yScale, c_white, 1);
	// right
	draw_sprite_part_ext(sprite, imgIndex, size * 2, size, size, 1, x1 + w - size, y1 + size, 1, yScale, c_white, 1);
	// top 
	draw_sprite_part_ext(sprite, imgIndex, size, 0, 1, size, x1 + size, y1, xScale, 1, c_white, 1);
	// bottom
	draw_sprite_part_ext(sprite, imgIndex, size, size * 2, 1, size, x1 + size, y1 + h - size, xScale, 1, c_white, 1);
}
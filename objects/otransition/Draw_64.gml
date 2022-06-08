if (type == TRANS_TYPE.SLIDE){
	draw_set_color(c_black);
	draw_rectangle(0,0, width, percent * heightHalf, false);
	draw_rectangle(0,height, width, height - (percent * heightHalf), false);
}

if (type == TRANS_TYPE.WIPE){
	draw_set_color(c_black);
	draw_rectangle(0, 0, width, percent * height, false);
}
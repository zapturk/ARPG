/// @description On Room start move cam to player

if(instance_exists(oPlayer)){
	xPos = oPlayer.x / RESOLUTION_W;
	xPos -= frac(xPos);
	xPos *= RESOLUTION_W;

	yPos = oPlayer.y / RESOLUTION_H;
	yPos -= frac(yPos);
	yPos *= RESOLUTION_H;
	
	camera_set_view_pos(cam, xPos,yPos);
}
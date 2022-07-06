// move cam to next room
desiredX = oPlayer.x / RESOLUTION_W;
desiredX -= frac(desiredX);
desiredX *= RESOLUTION_W;

desiredY = oPlayer.y / RESOLUTION_H;
desiredY -= frac(desiredY);
desiredY *= RESOLUTION_H;

dx = 0;
dy = 0;

// no panning
//camera_set_view_pos(cam, desiredX, desiredY);

// with panning
currentX = camera_get_view_x(cam);
currentY = camera_get_view_y(cam);

//Screenshake
dx += random_range(-shakeRemain, shakeRemain);
dy += random_range(-shakeRemain, shakeRemain);

shakeRemain = max(0, shakeRemain - ((1 / shakeLenth) * shakeMagnitude));	

//change maps
if(desiredX != currentX || desiredY != currentY){
	dx = clamp(desiredX - currentX, -panSpeed, +panSpeed);
	dy = clamp(desiredY - currentY, -panSpeed, +panSpeed);
}

camera_set_view_pos(cam, currentX + dx, currentY + dy);

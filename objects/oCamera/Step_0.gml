/// @description Update Camera

if (instance_exists(fallow)){
	xTo = fallow.x;
	yTo = fallow.y;
}

// update Obj pos
x += (xTo - x) / 10;
y += (yTo - y) / 10;

// keep camera center inside room
x = clamp(x, viewWidthHalf, room_width - viewWidthHalf);
y = clamp(y, viewHeightHalf, room_height - viewHeightHalf);

//Screenshake
x += random_range(-shakeRemain, shakeRemain);
y += random_range(-shakeRemain, shakeRemain);

shakeRemain = max(0, shakeRemain - ((1 / shakeLenth) * shakeMagnitude));

camera_set_view_pos(cam, x - viewWidthHalf, y - viewHeightHalf);

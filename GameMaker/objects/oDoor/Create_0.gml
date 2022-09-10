/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

image_speed = 0;


if(doorDir == "Right"){
	image_angle = -90;
}
else if(doorDir == "Down"){
	image_angle = 180;
}
else if(doorDir == "Left"){
	image_angle = 90;
}

if(enabled){
	image_index = 0;
	
}
else{
	image_index = 3;
}

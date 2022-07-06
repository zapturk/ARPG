/// @description Insert description here
// You can write your code in this editor



if(enabled && image_index == 3){
	image_speed = -1;
}

if(!enabled && image_index == 0){
	image_speed = 1;
}

if(enabled && image_index == 0){
	image_speed = 0;
}

if(!enabled && image_index == 3){
	image_speed = 0;
}

entityCollision = enabled;
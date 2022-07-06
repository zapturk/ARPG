/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

image_speed = 0;

if(color == "Red"){
	sprite_index = sBlockRed;
}
else if(color == "Blue"){
	sprite_index = sBlockBlue;
}
else if(color == "Green"){
	sprite_index = sBlockGreen;
}
else if(color == "Brown"){
	sprite_index = sBlockBrown;
}
else if(color == "Tan"){
	sprite_index = sBlockTan;
}

if(enabled){
	image_index = 0;
	
}
else{
	image_index = 3;
}

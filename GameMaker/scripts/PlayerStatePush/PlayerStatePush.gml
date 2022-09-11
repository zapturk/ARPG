// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function PlayerStatePush(){
	if(inputMagnitude != 0) {
		direction = inputDirection;
		sprite_index = spritePush;
		
		//Movement
		hSpeed = lengthdir_x(inputMagnitude * speedWalk, inputDirection);
		vSpeed = lengthdir_y(inputMagnitude * speedWalk, inputDirection);
		
		//update image index
		PlayerAnimateSprite();
	}
	else {
		state = PlayerStateFree;
	}
}
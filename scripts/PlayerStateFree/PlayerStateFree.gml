// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function PlayerStateFree(){
	//Movement
	hSpeed = lengthdir_x(inputMagnitude * speedWalk, inputDirection);
	vSpeed = lengthdir_y(inputMagnitude * speedWalk, inputDirection);

	PlayerCollision();

	// update sprite Index
	var oldSprite = sprite_index;

	if(inputMagnitude != 0) {
		direction = inputDirection;
		sprite_index = spriteWalk;
	}
	else {
		sprite_index = spriteIdle;
	}

	if(oldSprite != sprite_index){
		localFrame = 0;	
	}

	//update image index
	PlayerAnimateSprite();
	
	//Change State
	if (keyActivate){
		state = PlayerStateRoll;
		moveDistanceremaining = distanceRoll;
	}
}
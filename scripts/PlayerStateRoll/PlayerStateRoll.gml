// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function PlayerStateRoll(){
	hSpeed = lengthdir_x(speedRoll, direction);
	vSpeed = lengthdir_y(speedRoll, direction);
	
	moveDistanceremaining = max(0, moveDistanceremaining - speedRoll);
	var collided = PlayerCollision();
	
	// update sprite
	sprite_index = spriteJumpRoll;
	var totalFames = sprite_get_number(sprite_index) / 4;
	image_index = (CARDINAL_DIR * totalFames) + min(((1 - (moveDistanceremaining / distanceRoll)) * totalFames), totalFames - 1);
	
	// Change State
	if(moveDistanceremaining <= 0){
		state = PlayerStateFree;	
	}
	
	if(collided){
		state = PlayerStateBonk;
		moveDistanceremaining = distanceBonk;
		ScreenShake(2, 15);
	}
}
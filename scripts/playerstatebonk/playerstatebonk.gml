// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function PlayerStateBonk(){
	hSpeed = lengthdir_x(speedBonk, direction-180);
	vSpeed = lengthdir_y(speedBonk, direction-180);
	
	moveDistanceremaining = max(0, moveDistanceremaining - speedBonk);
	var collided = PlayerCollision();
	
	// update sprite
	sprite_index = spriteHurt;
	image_index = CARDINAL_DIR + 2;
	
	// cange height
	z = sin(((moveDistanceremaining / distanceBonk) * pi)) * distanceBonkHeight;
	
	// Change State
	if(moveDistanceremaining <= 0){
		state = PlayerStateFree;	
	}
}
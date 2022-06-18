// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function PlayerThrow(){
	with(global.iLifted){
		lifted = false;
		persistent = false;
		thrown = true;
		z = LIFT_OBJ_Z;
		throwPeakHeight = z + 10;
		throwDistance = entityThrowDistance;
		throwDistanceTraveled = 0;
		throwStartPercent = (LIFT_OBJ_Z/throwPeakHeight) * 0.5;
		throwPercent= throwStartPercent;
		direction = other.direction;
		xstart = x;
		ystart = y;
		entityShadow = true;
	}
	
	PlayerActOutAnimation(sPlayerThrow);
	global.iLifted = noone;
}
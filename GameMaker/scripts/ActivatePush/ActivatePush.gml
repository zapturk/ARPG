// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function ActivatePush(objId){
	// up
	if(oPlayer.direction == UP){
		objId.hspeed = 0;
		objId.vspeed = -2;
	}
	else if(oPlayer.direction == RIGHT){
		objId.hspeed = 2;
		objId.vspeed = 0;
	}
	else if(oPlayer.direction == DOWN){
		objId.hspeed = 0;
		objId.vspeed = 2;
	}
	else if(oPlayer.direction == LEFT){
		objId.hspeed = -2;
		objId.vspeed = 0;
	}
}
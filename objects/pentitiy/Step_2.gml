/// @desc Entity loop
if(!global.gamePaused){
	depth = -bbox_bottom;
	
	if(lifted && instance_exists(oPlayer)){
		if(oPlayer.sprite_index != sPlayerLift){
			x = oPlayer.x;
			y = oPlayer.y;
			z = 5;
			depth = oPlayer.depth - 1;
		}
	}
}

flash = max(flash - 0.04, 0);

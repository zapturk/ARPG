function PlayerAnimateSprite(){
	var totalFrames = sprite_get_number(sprite_index) / 4;
	image_index = localFrame + (CARDINAL_DIR * totalFrames);
	localFrame += sprite_get_speed(sprite_index) / FRAME_RATE;
	
	// if animation would loop on next game step
	if(localFrame >= totalFrames){
		animationEnd = true;
		localFrame -= totalFrames;
	}
	else {
		animationEnd = false;	
	}
}


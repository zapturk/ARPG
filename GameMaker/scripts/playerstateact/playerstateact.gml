function PlayerStateAct(){
	//Update Sprite
	PlayerAnimateSprite();
	
	if (animationEnd){
		state = PlayerStateFree;
		animationEnd = false;
		if (animationEndScript != -1){
			script_execute(animationEndScript);
		}
	}
}
function AttackSlash(){
	// set the attack animation
	if(sprite_index != sHeroAttack){
		sprite_index = sHeroAttack;
		localFrame = 0;
		image_index = 0;
	}
	
	// do attack calulation
	// TODO
	
	// Update sprite
	PlayerAnimateSprite();
	
	// set back to free state
	if(animationEnd){
		state = PlayerStateFree;
		animationEnd = false;
	}
}
function AttackSlash(){
	// set the attack animation
	if(sprite_index != sHeroAttack){
		sprite_index = sHeroAttack;
		localFrame = 0;
		image_index = 0;
		
		//clear hit by attack list
		if(!ds_exists(hitByAttack, ds_type_list)){
			hitByAttack = ds_list_create();
		}
		ds_list_clear(hitByAttack);
	}
	
	// do attack calulation
	CalcAttack(sHeroAttackHB);
	
	// Update sprite
	PlayerAnimateSprite();
	
	// set back to free state
	if(animationEnd){
		state = PlayerStateFree;
		animationEnd = false;
	}
}
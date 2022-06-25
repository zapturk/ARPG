function AttackSlash(){
	// set the attack animation
	if(sprite_index != spriteAttack){
		sprite_index = spriteAttack;
		localFrame = 0;
		
		//clear hit by attack list
		if(!ds_exists(hitByAttack, ds_type_list)){
			hitByAttack = ds_list_create();
		}
		ds_list_clear(hitByAttack);
	}
	
	// do attack calulation
	CalcAttack(spriteAttackHB);
	
	// Update sprite
	PlayerAnimateSprite();
	
	// set back to free state
	if(animationEnd){
		state = PlayerStateFree;
		animationEnd = false;
	}
}

function AttackSpin(){

}

function CalcAttack(hitBox){
	// use attack hitbox and check for hit
	mask_index = hitBox;
	var hitByAttackNow = ds_list_create();
	var hits = instance_place_list(x, y, pEntitiy, hitByAttackNow, false);
	
	if(hits > 0){
		for(var i = 0; i < hits; i++){
			// if this isntance has not been hit by this attack then hit it.
			var hitID = hitByAttackNow[| i];
			
			if(ds_list_find_index(hitByAttack, hitID) == -1){
				ds_list_add(hitByAttack, hitID);
				with (hitID){
					if(object_is_ancestor(object_index, pEnemy)){
						HurtEnemy(id, 1, other.id, 10);
					}
					else if(entityHitScript != -1){
						script_execute(entityHitScript);
					}
				}
			}
		}
	}
	
	ds_list_destroy(hitByAttackNow);
	mask_index = spriteIdle;
}

function HurtEnemy(enemey, damage, source, knockBack){
	with(enemey){
		if(state != ENEMYSTATE.DIE){
			enemyHP -= damage;
			
			// hurt or dead
			if(enemyHP <= 0){
				image_index = 0;
				state = ENEMYSTATE.DIE;
			}
			else{ 
				if(state != ENEMYSTATE.HURT){
					flash = .5;
					statePrevious = state;
				}
				state = ENEMYSTATE.HURT;
				image_index = 0;
				
				if(knockBack != 0){
					var knockBackDir = point_direction(x,y, source.x, source.y);
					xTo = x - lengthdir_x(knockBack, knockBackDir);
					yTo = y - lengthdir_y(knockBack, knockBackDir);
				}
			}
		}
	}
}
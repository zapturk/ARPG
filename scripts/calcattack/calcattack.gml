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
					
					if (entityHitScript != -1){
						script_execute(entityHitScript);
					}
				}
			}
		}
	}
	
	ds_list_destroy(hitByAttackNow);
	mask_index = spriteIdle;
}
function PlayerCollision(){
	var collision = false;
	var entityList = ds_list_create()
	
	// Horizontal Tiles
	// Check Right
	if(tilemap_get_at_pixel(collisionMap, bbox_right + hSpeed, bbox_bottom)){
		while(!tilemap_get_at_pixel(collisionMap, bbox_right + hSpeed, bbox_bottom)){
			x += sign(oPlayer.hSpeed);
		}
		hSpeed = 0;
		collision = true;
	}
	
	// Check Left
	if(tilemap_get_at_pixel(collisionMap, bbox_left + hSpeed, bbox_bottom)){
		while(!tilemap_get_at_pixel(collisionMap, bbox_left + hSpeed, bbox_bottom)){
			oPlayer.x += sign(hSpeed);
		}
		hSpeed = 0;
		collision = true;
	}
	
	//horizontal Entities
	var entityCount = instance_position_list(x + hSpeed, y, pEntitiy, entityList, false);
	var snapX;
	
	while(entityCount > 0){
		var entityCheck = entityList[| 0];
		if(entityCheck.entityCollision == true){
			// move as close as we can
			if(sign(hSpeed) == -1){
				snapX = entityCheck.bbox_right + 1;
			}
			else{
				snapX = entityCheck.bbox_left - 1;
			}
			
			x = snapX;
			hSpeed = 0;
			collision = true;
			entityCount = 0;
		}
		
		ds_list_delete(entityList, 0);
		entityCount--;
	}
	
	// Horizontal movement
	x += hSpeed;
	
	//clear lsi between asix
	ds_list_clear(entityList);
	
	// Vertical Tiles
	// Check Left
	if(tilemap_get_at_pixel(collisionMap, bbox_left, bbox_top + vSpeed)){
		while(!tilemap_get_at_pixel(collisionMap, bbox_left, bbox_top + vSpeed)){
			y += sign(vSpeed);
		}
		vSpeed = 0;
		collision = true;
	}
	
	// Check Right
	if(tilemap_get_at_pixel(collisionMap, bbox_right, bbox_bottom + vSpeed)){
		while(!tilemap_get_at_pixel(collisionMap, bbox_right, bbox_bottom + vSpeed)){
			y += sign(vSpeed);
		}
		vSpeed = 0;
		collision = true;
	}
	
	//vartical Entities
	var entityCount = instance_position_list(x, y + vSpeed, pEntitiy, entityList, false);
	var snapY;
	
	while(entityCount > 0){
		var entityCheck = entityList[| 0];
		if(entityCheck.entityCollision == true){
			// move as close as we can
			if(sign(vSpeed) == -1){
				snapY = entityCheck.bbox_bottom + 1;
			}
			else{
				snapY = entityCheck.bbox_top - 1;
			}
			
			y = snapY;
			vSpeed = 0;
			collision = true;
			entityCount = 0;
		}
		
		ds_list_delete(entityList, 0);
		entityCount--;
	}
	
	// Vertical movement
	y += vSpeed;
	
	// delete list
	ds_list_destroy(entityList);
	
	return collision;
}
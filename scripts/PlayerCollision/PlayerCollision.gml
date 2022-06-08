// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function PlayerCollision(){
	var collision = false;
	var entityList = ds_list_create()
	
	// Horizontal Tiles
	if(tilemap_get_at_pixel(collisionMap, x + hSpeed, y)){
		x -= x mod TILE_SIZE;
		if(sign(hSpeed) == 1){
			x += TILE_SIZE - 1;
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
				snapX = entityCheck.bbox_right+1;
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
	if(tilemap_get_at_pixel(collisionMap, x, y + vSpeed)){
		y -= y mod TILE_SIZE;
		if(sign(vSpeed) == 1){
			y += TILE_SIZE - 1;
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
				snapY = entityCheck.bbox_bottom+1;
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
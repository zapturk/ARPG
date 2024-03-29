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
	else if(tilemap_get_at_pixel(collisionMap, bbox_right + hSpeed, bbox_top)){
		while(!tilemap_get_at_pixel(collisionMap, bbox_right + hSpeed, bbox_top)){
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
	else if(tilemap_get_at_pixel(collisionMap, bbox_left + hSpeed, bbox_top)){
		while(!tilemap_get_at_pixel(collisionMap, bbox_left + hSpeed, bbox_top)){
			oPlayer.x += sign(hSpeed);
		}
		hSpeed = 0;
		collision = true;
	}
	
	// horizontal Entities
	// check right
	if(position_meeting(bbox_right + hSpeed, bbox_bottom, pEntitiy)){
		var inst = instance_position(bbox_right + hSpeed, bbox_bottom, pEntitiy);
		
		if(inst.entityCollision){
			while(!position_meeting(bbox_right + hSpeed, bbox_bottom, pEntitiy)){
				x += sign(oPlayer.hSpeed);
			}
			hSpeed = 0;
			collision = true;
			
			if(inst.entityPush){
				
				script_execute(ScriptExecuteArray(inst.entityActivateScript, inst.entityActivateArgs));
			}
		}
	}
	else if(position_meeting(bbox_right + hSpeed, bbox_top, pEntitiy)){
		var inst = instance_position(bbox_right + hSpeed, bbox_top, pEntitiy);
		
		if(inst.entityCollision){
			while(!position_meeting(bbox_right + hSpeed, bbox_top, pEntitiy)){
				x += sign(oPlayer.hSpeed);
			}
			hSpeed = 0;
			collision = true;
			
			if(inst.entityPush){
				
				script_execute(ScriptExecuteArray(inst.entityActivateScript, inst.entityActivateArgs));
			}
		}
	}
	
	// check left
	if(position_meeting(bbox_left + hSpeed, bbox_bottom, pEntitiy)){
		var inst = instance_position(bbox_left + hSpeed, bbox_bottom, pEntitiy);
		
		if(inst.entityCollision){
			while(!position_meeting(bbox_left + hSpeed, bbox_bottom, pEntitiy)){
				x += sign(oPlayer.hSpeed);
			}
			hSpeed = 0;
			collision = true;
			
			if(inst.entityPush){
				
				script_execute(ScriptExecuteArray(inst.entityActivateScript, inst.entityActivateArgs));
			}
		}
	}
	else if(position_meeting(bbox_left + hSpeed, bbox_top, pEntitiy)){
		var inst = instance_position(bbox_left + hSpeed, bbox_top, pEntitiy);
		
		if(inst.entityCollision){
			while(!position_meeting(bbox_left + hSpeed, bbox_top, pEntitiy)){
				x += sign(oPlayer.hSpeed);
			}
			hSpeed = 0;
			collision = true;
			
			if(inst.entityPush){
				
				script_execute(ScriptExecuteArray(inst.entityActivateScript, inst.entityActivateArgs));
			}
		}
	}
	
	// Horizontal movement
	x += hSpeed;
	
	//clear list between frames
	ds_list_clear(entityList);
	
	// Vertical Tiles
	// Check up
	if(tilemap_get_at_pixel(collisionMap, bbox_left, bbox_top + vSpeed)){
		while(!tilemap_get_at_pixel(collisionMap, bbox_left, bbox_top + vSpeed)){
			y += sign(vSpeed);
		}
		vSpeed = 0;
		collision = true;
	}
	else if(tilemap_get_at_pixel(collisionMap, bbox_right, bbox_top + vSpeed)){
		while(!tilemap_get_at_pixel(collisionMap, bbox_right, bbox_top + vSpeed)){
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
	else if(tilemap_get_at_pixel(collisionMap, bbox_left, bbox_bottom + vSpeed)){
		while(!tilemap_get_at_pixel(collisionMap, bbox_left, bbox_bottom + vSpeed)){
			y += sign(vSpeed);
		}
		vSpeed = 0;
		collision = true;
	}
	
	//vartical Entities
	// Check up
	if(position_meeting(bbox_left, bbox_top + vSpeed, pEntitiy)){
		var inst = instance_position(bbox_left, bbox_top + vSpeed, pEntitiy);
		
		if(inst.entityCollision){
			while(!position_meeting(bbox_left, bbox_top + vSpeed, pEntitiy)){
				y += sign(vSpeed);
			}
			vSpeed = 0;
			collision = true;
			
			if(inst.entityPush){
				
				script_execute(ScriptExecuteArray(inst.entityActivateScript, inst.entityActivateArgs));
			}
		}
	}
	else if(position_meeting(bbox_right, bbox_top + vSpeed, pEntitiy)){
		var inst = instance_position(bbox_right, bbox_top + vSpeed, pEntitiy);
		
		if(inst.entityCollision){
			while(!position_meeting(bbox_right, bbox_top + vSpeed, pEntitiy)){
				y += sign(vSpeed);
			}
			vSpeed = 0;
			collision = true;
			
			if(inst.entityPush){
				
				script_execute(ScriptExecuteArray(inst.entityActivateScript, inst.entityActivateArgs));
			}
		}
	}
	
	// Check down
	if(position_meeting(bbox_right, bbox_bottom + vSpeed, pEntitiy)){
		var inst = instance_position(bbox_right, bbox_bottom + vSpeed, pEntitiy);
		
		if(inst.entityCollision){
			while(!position_meeting(bbox_right, bbox_bottom + vSpeed, pEntitiy)){
				y += sign(vSpeed);
			}
			vSpeed = 0;
			collision = true;
			
			if(inst.entityPush){
				
				script_execute(ScriptExecuteArray(inst.entityActivateScript, inst.entityActivateArgs));
			}
		}
	}
	else if(position_meeting(bbox_left, bbox_bottom + vSpeed, pEntitiy)){
		var inst = instance_position(bbox_left, bbox_bottom + vSpeed, pEntitiy);
		
		if(inst.entityCollision){
			while(!position_meeting(bbox_left, bbox_bottom + vSpeed, pEntitiy)){
				y += sign(vSpeed);
			}
			vSpeed = 0;
			collision = true;
			
			if(inst.entityPush){
				script_execute(ScriptExecuteArray(inst.entityActivateScript, inst.entityActivateArgs));
			}
		}
	}
	
	// Vertical movement
	y += vSpeed;
	
	// delete list
	ds_list_destroy(entityList);
	
	return collision;
}
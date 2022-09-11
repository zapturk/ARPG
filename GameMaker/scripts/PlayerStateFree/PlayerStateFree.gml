function PlayerStateFree(){
	// Check for stairs
	if(position_meeting(x, y, oStairs)){
		speedWalk = 1.0;
	}
	else{
		speedWalk = 2.0;
	}
	
	if(position_meeting(x, y, oFall)){
		state = PlayerStateFall;
	}
	
	//Movement
	hSpeed = lengthdir_x(inputMagnitude * speedWalk, inputDirection);
	vSpeed = lengthdir_y(inputMagnitude * speedWalk, inputDirection);
	

	var collision = PlayerCollision();
	
	// attack key logic
	if(keyAttack){
		state = PlayerStateAttack;
		stateAttack = AttackSlash;
	}

	// update sprite Index
	var oldSprite = sprite_index;

	if(inputMagnitude != 0) {
		direction = inputDirection;
		if(collision){
			sprite_index = spritePush;
		}
		else{
			sprite_index = spriteWalk;
		}
	}
	else {
		sprite_index = spriteIdle;
	}

	if(oldSprite != sprite_index){
		localFrame = 0;	
	}

	//update image index
	PlayerAnimateSprite();
	
	// Activate key logic
	if (keyActivate){
		// Check for an entity to activate
		var activateX = x + lengthdir_x(10, direction);
		var activateY = y + lengthdir_y(10, direction);
		var activateSize = 4;
		var activateList = ds_list_create();
		activate = noone;
		
		var entityFound = collision_rectangle_list(
			activateX - activateSize,
			activateY - activateSize,
			activateX + activateSize,
			activateY + activateSize,
			pEntitiy,
			false,
			true,
			activateList,
			true
		);
		
		//if the frist instance we find is ether out lifted entity or has no script try the next one
		while(entityFound > 0){
			var check = activateList[| --entityFound];
			if (check != global.iLifted && check.entityActivateScript != -1){
				activate = check;
				break;
			}
		}
		
		
		ds_list_destroy(activateList);
		
		// if there is nothing, or somthing with no sctipt then roll
		if(activate == noone){
			//throw something if held otherwise roll
			if(global.iLifted != noone){
				PlayerThrow();
			}
		}
		else{ // otherwise, there is a somthing and it has a script activate
			script_execute(ScriptExecuteArray(activate.entityActivateScript, activate.entityActivateArgs));
			
				if(activate.entityTresure){
					activate.entityActivateScript = -1;
					activate.image_index = 1;
				}
			
			// if the thing we actavet is an NPC make it face towards us
			if(activate.entityNPC){
				with(activate){
					direction = point_direction(x, y, other.x, other.y);
					image_index = CARDINAL_DIR;
				}
			}
		}	
	}
}
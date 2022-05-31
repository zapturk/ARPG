function PlayerStateFree(){
	//Movement
	hSpeed = lengthdir_x(inputMagnitude * speedWalk, inputDirection);
	vSpeed = lengthdir_y(inputMagnitude * speedWalk, inputDirection);

	PlayerCollision();
	
	// attack key logic
	if(keyAttack){
		state = PlayerStateAttack;
		stateAttack = AttackSlash;
	}

	// update sprite Index
	var oldSprite = sprite_index;

	if(inputMagnitude != 0) {
		direction = inputDirection;
		sprite_index = spriteWalk;
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
		var activateX = lengthdir_x(10, direction);
		var activateY = lengthdir_y(10, direction);
		activate = instance_position(x + activateX, y + activateY, pEntitiy);
		
		// if there is nothing, or somthing with no sctipt then roll
		if(activate == noone || activate.entityActivateScript == -1){
			state = PlayerStateRoll;
			moveDistanceremaining = distanceRoll;
		}
		else{ // otherwise, there is a somthing and it has a script activate
			script_execute(ScriptExecuteArray(activate.entityActivateScript, activate.entityActivateArgs));
			
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
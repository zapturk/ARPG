function SlimeAttack(){
	// How fast to move
	var spd = enemySpeed * 2;
	
	//dont move while still getting ready to jump
	if (image_index < 2){
		spd = 0;
	}
	
	//Freeze animation in mid air and after landing
	if(floor(image_index) == 3 || floor(image_index) == 5){
		image_speed = 0;
	}
	
	// how far we need to jump
	var disToGo = point_distance(x, y, xTo, yTo);
	
	// begin landing animation
	if(disToGo < 4 && image_index < 5){
		image_speed = 1;
	}
	
	//move 
	if(disToGo > spd){
		dir = point_direction(x, y, xTo, yTo);
		hSpeed = lengthdir_x(spd, dir);
		vSpeed = lengthdir_y(spd, dir);
		
		//stop if you hit a wall
		if(EnemyTileCollision()){
			xTo = x;
			yTo = y;
		}
	}
	else{
		x = xTo;
		y = yTo;
		if(floor(image_index) == 5){
			stateTarget = ENEMYSTATE.CHASE;
			stateWaitDuration = 15;
			state = ENEMYSTATE.WAIT;
		}
	}
}

function SlimeChase(){
	sprite_index = sprMove;
	image_speed = 1;
	if(instance_exists(target)){
		xTo = target.x;
		yTo = target.y;
		
		var disToGo = point_distance(x, y, xTo, yTo);
		dir = point_direction(x, y, xTo, yTo);
		if(disToGo > enemySpeed){
			hSpeed = lengthdir_x(enemySpeed, dir);
			vSpeed = lengthdir_y(enemySpeed, dir);
		}
		else{
			hSpeed = lengthdir_x(disToGo, dir);
			vSpeed = lengthdir_y(disToGo, dir);
		}
		
		//collide and move
		EnemyTileCollision();
	}
	
	//check if close 
	if(instance_exists(target) && point_distance(x, y, target.x, target.y) <= enemyAttackRadius){
		state = ENEMYSTATE.ATTACK;
		
		//set the sprites
		sprite_index = sprAttack;
		image_speed = 1;
		
		//target a pixel past the player
		xTo += lengthdir_x(8, dir);
		yTo += lengthdir_y(16, dir);
	}
}

function SlimeWonder(){
	image_speed = 1;
	sprite_index = sprMove;
	// At Destination or given up?
	if(((x == xTo) && (y == yTo)) || (timePassed > enemyWonderDistance / enemySpeed)){
		hSpeed = 0;
		vSpeed = 0;
		
		// new target destinaiton
		if(++wait >= waitDuration){
			wait = 0;
			timePassed = 0;
			dir = point_direction(x, y, xstart, ystart) + irandom_range(-45, 45);
			xTo = x + lengthdir_x(enemyWonderDistance, dir);
			yTo = y + lengthdir_y(enemyWonderDistance, dir);
		}
	}
	else{ // Move to Destinaion
		timePassed++;
		image_speed = 1;
		var distToGo = point_distance(x, y, xTo, yTo);
		var speedThisFrame = enemySpeed;
		if(distToGo < enemySpeed){
			speedThisFrame = distToGo;
		}
		dir = point_direction(x, y, xTo, yTo);
		hSpeed = lengthdir_x(speedThisFrame, dir);
		vSpeed = lengthdir_y(speedThisFrame, dir);
		
		//collide & move
		EnemyTileCollision();
	}
	
	//check for agrro
	if(++aggroCheck >= aggroCheckDuration){
		aggroCheck = 0;
		if(instance_exists(oPlayer) && (point_distance(x,y, oPlayer.x, oPlayer.y) <= enemyAggroRadius)){
			state = ENEMYSTATE.CHASE;
			target = oPlayer;
		}
	}
	
	
}
	
function SlimeHurt(){
	sprite_index = sprHurt;
	var disToGo = point_distance(x, y, xTo, yTo);
	if(disToGo > enemySpeed){
		image_speed = 1;
		dir = point_direction(x, y, xTo, yTo);
		hSpeed = lengthdir_x(enemySpeed, dir);
		vSpeed = lengthdir_y(enemySpeed, dir);
		
		//Collide and move
		if(EnemyTileCollision()){
			xTo = x;
			yTo = y;
		}
		else{
			x = xTo;
			y = yTo;
			if(statePrevious != ENEMYSTATE.ATTACK){
				state = statePrevious;
			}
			else {
				state = ENEMYSTATE.CHASE;
			}
		}
	}
}

function SlimeDie(){
	sprite_index = sprDie;
	image_speed = 1;
	//var disToGo = point_distance(x, y, xTo, yTo);
	
	if(image_index + (sprite_get_speed(sprite_index) / game_get_speed(gamespeed_fps)) >= image_number){
		instance_destroy();
	}
	
}
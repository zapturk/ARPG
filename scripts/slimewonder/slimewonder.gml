function SlimeWonder(){
	// At Destination or given up?
	if(((x == xTo) && (y == yTo)) || (timePassed > enemyWonderDistance / enemySpeed)){
		hSpeed = 0;
		vSpeed = 0;
		// end move
		//if(image_index < 1){
		//	image_speed = 0;
		//	image_index = 0;
		//}
		
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
	
	
}
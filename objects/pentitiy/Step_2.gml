/// @desc Entity loop
if(!global.gamePaused){
	depth = 0;
	
	if(lifted && instance_exists(oPlayer)){
		if(oPlayer.sprite_index != sPlayerLift){
			x = oPlayer.x;
			y = oPlayer.y;
			z = LIFT_OBJ_Z;
			depth = oPlayer.depth - 1;
		}
	}
	
	if(!lifted){
		// be thrown
		if(thrown){
			throwDistanceTraveled = min(throwDistanceTraveled + 3, throwDistance);
			x = xstart + lengthdir_x(throwDistanceTraveled, direction);
			y = ystart + lengthdir_y(throwDistanceTraveled, direction);
			
			if (tilemap_get_at_pixel(collisionMap, x, y) > 0){
				thrown = false;
				grav = 0.1;
			}
			
			throwPercent = throwStartPercent + lerp(0, 1 - throwStartPercent, throwDistanceTraveled / throwDistance);
			z = throwPeakHeight * sin(throwPercent * pi);
			if(throwDistance == throwDistanceTraveled){
				thrown = false;
				if(entityThrowBreak){
					instance_destroy();
				}
			}
		}
		else{
			if(z > 0){
				z = max(z - grav, 0);
				grav += 0.1;
				if (z == 0 && entityThrowBreak){
					instance_destroy();
				}
			}
			else{
				grav = 0.1;
			}
		}
	}
}

flash = max(flash - 0.04, 0);

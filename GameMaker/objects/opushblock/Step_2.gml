/// @description Insert description here
// You can write your code in this editor


// Inherit the parent event
event_inherited();

if place_snapped(8,8) = 1 {
	
	if(speed > 0){
		shiftCounter--;
	
		if(shiftCounter == 0){
			speed = 0;
			shiftCounter = 2;
		}
	}
}
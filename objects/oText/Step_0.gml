lerpProgress += (1 - lerpProgress) / 50;
textProgress += global.textSpeed;

x1 = lerp(x1, x1Target, lerpProgress);
x2 = lerp(x2, x2Target, lerpProgress);

// Cycle throught resposes
keyUp = keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"));
keyDown = keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"));
responseSelected += (keyDown - keyUp);
var maxResponse = array_length(responses) - 1;
var minResponse = 0;
if (responseSelected > maxResponse){
	responseSelected = minResponse;
}

if (responseSelected < minResponse){
	responseSelected = maxResponse;
}

if (keyboard_check_pressed(vk_space)){
	var messageLenght = string_length(messageText);
	if(textProgress >= messageLenght){
		instance_destroy();
		if(instance_exists(oTextQueued)){
			with(oTextQueued){
				ticket--;
			}
		}
		else{
			with (oPlayer){
				state = lastState;
			}
		}
	}
	else{
		if(textProgress > 2){
			textProgress = messageLenght;
		}
	}
}

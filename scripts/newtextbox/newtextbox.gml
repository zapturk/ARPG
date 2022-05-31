function NewTextBox(newMessage, boxBackground = 0, responsesOptions = [-1]){
	var obj;
	if(instance_exists(oText)){
		obj = oTextQueued;
	}
	else{
		obj = oText;
	}
	
	//this will create and use new obj
	with(instance_create_layer(0, 0, "Instances", obj)){
		messageText = newMessage;
		
		// set the obj that we are talking to
		if(instance_exists(other)){
			originInstance = other.id;
		}
		else{
			originInstance = noone;
		}
		
		if(responsesOptions[0] != -1) {
			// trim responces
			for (var i = 0; i < array_length(responsesOptions); i++){
				var markerPostion = string_pos(":", responsesOptions[i]);
				responseScript[i] = string_copy(responsesOptions[i], 1, markerPostion - 1);
				responseScript[i] = real(responseScript[i]);
				responses[i] = string_copy(responsesOptions[i], markerPostion + 1, string_length(responsesOptions[i]));
			}
		}
		else{
			// there are no responses to message
			responses = [-1];
			responseScript = [-1];
		}
		
		background = boxBackground;
	}
	
	with(oPlayer){
		if(state != PlayerStateLocked){
			lastState = state;
			state = PlayerStateLocked;
		}
	}
}
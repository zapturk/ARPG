function NewTextBox(newMessage, boxBackground = 0){
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
		if(instance_exists(other)){
			originInstance = other.id;
		}
		else{
			originInstance = noone;
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
function RoomTransition(transType, targetRoom){

	if(!instance_exists(oTransition)){
		with(instance_create_depth(0, 0, -9999, oTransition)){
			type = transType;
			target = targetRoom;
		}
	}
	else{
		show_debug_message("Trying to transition is happening!");
	}
}
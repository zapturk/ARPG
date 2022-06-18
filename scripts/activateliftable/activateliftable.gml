function ActivateLiftable(objId){
	if(global.iLifted == noone){
		PlayerActOutAnimation(sPlayerLift);
		
		global.iLifted = objId;
		with(global.iLifted){
			lifted = true;
			persistent = true;
			entityShadow = false;
		}
	}
}
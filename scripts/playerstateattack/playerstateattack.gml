function PlayerStateAttack(){
	if(global.hasSword){
		script_execute(stateAttack)
	}
	else{
		state = PlayerStateFree;
	}
}
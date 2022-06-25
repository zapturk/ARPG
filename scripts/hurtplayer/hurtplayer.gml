function HurtPlayer(dir, force, damage){
	if(oPlayer.invonlnerable <= 0){
		global.playerHealth = max(0, global.playerHealth-damage);
		
		if(global.playerHealth > 0){
			with(oPlayer){
				state = PlayerStateBonk;
				direction = dir - 180;
				moveDistanceremaining = force;
				ScreenShake(2, 10);
				flash = .7;
				invonlnerable = 60;
			}
		}
		else{
			// Kill the player
		}
	}
}
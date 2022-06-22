// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function PlayerStateFall(){
	if(sprite_index != spriteFall){
		sprite_index = spriteFall;
		localFrame = 0;
		image_index = 0;
	}
	
	// Update sprite
	PlayerAnimateSprite();
	
	// set back to free state
	if(animationEnd){
		// Move Player back to safe spot
		var group = 0;
		for (var k = 0; k < instance_number(oPlayerRespawn); ++k)
		{
			var respawner = instance_find(oPlayerRespawn,k);
			if(respawner.group == group){
				oPlayer.x = respawner.x;
				oPlayer.y = respawner.y;
			}
		}
		
		state = PlayerStateFree;
		animationEnd = false;
	}
}
// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function PlayerActOutAnimation(Sprite, EndScript = -1){
	state = PlayerStateAct;
	sprite_index = Sprite;
	if(EndScript != -1){
		animationEndScript = EndScript;
	}
	localFrame = 0
	image_index = 0;
	PlayerAnimateSprite();
}
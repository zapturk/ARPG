state = PlayerStateFree;
stateAttack = AttackSlash;
hitByAttack = -1;
lastState = state;

collisionMap = layer_tilemap_get_id(layer_get_id("Col"));

image_speed = 0;
hSpeed = 0;
vSpeed = 0;
speedWalk = 2.0;
speedRoll = 3.0;
distanceRoll = 42;
distanceBonk = 25;
distanceBonkHeight = 6;
speedBonk = 1.5;
z = 0;

spriteWalk = sHeroWalk;
spriteIdle = sHeroIdle;
spriteAttack = sHeroAttack;
spriteAttackHB = sHeroAttackHB;
spriteHurt = sHeroHurt;
spriteJumpRoll = sHeroJumpRoll;
spritePush = sHeroPush;

localFrame = 0;

if(global.targetX != -1){
	x = global.targetX;
	y = global.targetY;
	direction = global.targetDirection;
}
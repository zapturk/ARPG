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

animationEndScript = -1;

spriteWalk = sPlayerWalk;
spriteIdle = sPlayerIdle;
spriteAttack = sPlayerAttack;
spriteAttackHB = sPlayerAttackHB;
spriteHurt = sPlayerHurt;
spriteJumpRoll = sPlayerRoll;
spritePush = sPlayerPush;
spriteFall = sPlayerFall;

localFrame = 0;

if(global.targetX != -1){
	x = global.targetX;
	y = global.targetY;
	direction = global.targetDirection;
}

depth = -1000;
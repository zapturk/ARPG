state = PlayerStateFree;
lastState = state;

collisionMap = layer_tilemap_get_id(layer_get_id("Col"));

image_speed = 0;
hSpeed = 0;
vSpeed = 0;
speedWalk = 2.0;
speedRoll = 3.0;
distanceRoll = 42;

spriteWalk = sHeroWalk;
spriteIdle = sHeroIdle;
spriteAttack = sHeroAttack;
spriteHurt = sHeroHurt;
spriteJumpRoll = sHeroJumpRoll;
spritePush = sHeroPush;

localFrame = 0;

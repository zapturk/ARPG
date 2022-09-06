/// @desc Initialize & Globls
randomize();

global.gamePaused = false;
global.textSpeed = 0.75;
global.targetRoom = -1;
global.targetX = -1;
global.targetDirection = 0;
global.playerHealthMax = 10;
global.playerHealth = global.playerHealthMax;
global.playerMoney = 0;

global.iLifted = noone;
global.iCamera = instance_create_layer(0, 0, layer, oCamera2);
global.iUI = instance_create_layer(0, 0, layer, oUI);


surface_resize(application_surface, RESOLUTION_W, RESOLUTION_H);
window_set_size(RESOLUTION_W * 6, RESOLUTION_H * 6);



room_goto(ROOM_START);


// PlayerState
global.hasSword = true;
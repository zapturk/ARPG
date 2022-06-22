/// @desc Initialize & Globls
randomize();

global.gamePaused = false;
global.textSpeed = 0.75;
global.targetRoom = -1;
global.targetX = -1;
global.targetDirection = 0;
global.iLifted = noone;

global.iCamera = instance_create_layer(0, 0, layer, oCamera2);

surface_resize(application_surface, RESOLUTION_W, RESOLUTION_H);

room_goto(ROOM_START);


// PlayerState
global.hasSword = false;
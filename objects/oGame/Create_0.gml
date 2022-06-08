/// @desc Initialize & Globls
randomize();

global.gamePaused = false;
global.textSpeed = 0.75;
global.targetRoom = -1;
global.targetX = -1;
global.targetDirection = 0;

global.iCamera = instance_create_layer(0, 0, layer, oCamera);

surface_resize(application_surface, RESOLUTION_W, RESOLUTION_H);

room_goto(ROOM_START);

#macro FRAME_RATE 60
#macro TILE_SIZE 16
#macro CARDINAL_DIR round(direction/90)
#macro ROOM_START rOverworld

#macro RESOLUTION_W 160
#macro RESOLUTION_H 144

#macro TRANSITION_SPEED 0.02
#macro OUT 0
#macro IN 1

#macro LIFT_OBJ_Z 13
#macro ORIGIN_OFFSET 8

#macro UP 90
#macro RIGHT 0
#macro DOWN 270
#macro LEFT 180

enum ENEMYSTATE{
	IDLE,
	WONDER,
	CHASE,
	ATTACK,
	HURT,
	DIE,
	WAIT
}
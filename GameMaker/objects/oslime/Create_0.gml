/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

// Default state
state = ENEMYSTATE.WONDER;

sprSpawn = sGreenSlimeIdle;
sprMove = sGreenSlimeIdle;
sprAttack = sGreenSlimeAttack;
sprHurt = sGreenSlimeHurt;
sprDie = sEnemieKillGreen;

enemyScript[ENEMYSTATE.WONDER] = SlimeWonder;
enemyScript[ENEMYSTATE.CHASE] = SlimeChase;
enemyScript[ENEMYSTATE.ATTACK] = SlimeAttack;
enemyScript[ENEMYSTATE.HURT] = SlimeHurt;
enemyScript[ENEMYSTATE.DIE] = SlimeDie;

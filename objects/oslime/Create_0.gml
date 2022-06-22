/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

// Default state
state = ENEMYSTATE.WONDER;

sprMove = sGreenSlimeIdle;

enemyScript[ENEMYSTATE.WONDER] = SlimeWonder;

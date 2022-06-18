/// @description Insert description here
// You can write your code in this editor
if(!position_meeting(x, y, objToSpawn)){
	if(!IsInView(self)){
		instance_create_layer(x, y, "Instances", objToSpawn);
	}
}
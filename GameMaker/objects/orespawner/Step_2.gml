/// @description Insert description here
// You can write your code in this editor
if(!collision_rectangle(bbox_left + 1, bbox_top + 1, bbox_right - 1, bbox_bottom - 1, objToSpawn, false, true)){
	if(!IsInView(self)){
		instance_create_layer(x, y, "Instances", objToSpawn);
	}
}
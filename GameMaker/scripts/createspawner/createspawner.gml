// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function createspawner(obj, newObj){
	if(!collision_rectangle(obj.bbox_left + 1, obj.bbox_top + 1, obj.bbox_right - 1, obj.bbox_bottom - 1, oRespawner, false, true)){
		var inst = instance_create_layer(obj.x, obj.y, "Instances", oRespawner);
		with(inst){
			objToSpawn = newObj;
		}
	}
}
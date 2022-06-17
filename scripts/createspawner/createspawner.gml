// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function createspawner(obj, newObj){
	if(!position_meeting(obj.x, obj.y, oRespawner)){
		var inst = instance_create_layer(obj.x, obj.y, "Instances", oRespawner);
		with(inst){
			objToSpawn = newObj;
		}
	}
}
/// @description Insert description here
// You can write your code in this editor

if(PressureSwitch && image_index == 1){
	if(collision_rectangle(bbox_left,bbox_top, bbox_right, bbox_bottom, oPlayer, false, true) == noone &&
	   collision_rectangle(bbox_left,bbox_top, bbox_right, bbox_bottom, oPushBlock, false, true) == noone){
		image_index = 0;
	}
	
	if(image_index == 0){
		for(var i = 0; i < array_length(ToggleGroups); i++){
			for (var k = 0; k < instance_number(ToggleObj); ++k)
			{
				obj = instance_find(ToggleObj,k);
				if(obj.group == ToggleGroups[i]){
					obj.enabled = !obj.enabled;
				}
			}
		}
	}
}
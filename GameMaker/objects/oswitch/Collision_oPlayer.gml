/// @description Insert description here
// You can write your code in this editor

if(image_index != 1){
	image_index = 1;

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
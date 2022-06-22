/// @description Insert description here
// You can write your code in this editor

if(image_index != 1){
	image_index = 1;

	for(var i = 0; i < array_length(ToggleGroups); i++){
		for (var k = 0; k < instance_number(oBlocker); ++k)
		{
			blocker = instance_find(oBlocker,k);
			if(blocker.group == ToggleGroups[i]){
				blocker.enabled = !blocker.enabled;
			}
		}
	}
}
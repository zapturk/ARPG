// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function DropItems(x, y, itemArr){

	var items = array_length(itemArr);
	
	if( items > 1){
		var anglePerItem = 360/items;
		var angle = random(360);
		for(var i = 0; i < items; i++){
			with(instance_create_layer(x, y, "Instances", itemArr[i])){
				direction = angle;
				spd = 0.75 + (items * 0.1) + random(0.1);
			}
			
			angle += anglePerItem;
		}
	}
	else{
		instance_create_layer(x, y, "Instances", itemArr[0])
	}
}
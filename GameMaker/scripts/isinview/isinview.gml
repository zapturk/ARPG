
function IsInView(obj){
	with(obj){
		var view_x = camera_get_view_x(view_camera[0]);
		var view_y = camera_get_view_y(view_camera[0]);
		var view_w = camera_get_view_width(view_camera[0]);
		var view_h = camera_get_view_height(view_camera[0]);
		
		return (x > view_x) && (y > view_y) && (x < view_x+view_w) && (y < view_y+view_h);
	}
}
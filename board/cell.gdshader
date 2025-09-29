shader_type canvas_item;
render_mode unshaded;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform vec2 mouse_position = vec2(0);

void vertex() {
	if (mouse_position != vec2(0)) {
		vec2 vec_to_mouse = mouse_position - VERTEX;
		float dist_to_mouse = distance(mouse_position, VERTEX);
		vec_to_mouse *= 0.1 * dist_to_mouse;
		VERTEX -= vec_to_mouse * 0.1;
	}
}

//void fragment() {
	//vec4 c = textureLod(screen_texture, SCREEN_UV, 0.0);
//
	//if (c.a > 0.0001) {
		//c.rgb /= c.a;
	//}
//
	//COLOR *= c;
//}
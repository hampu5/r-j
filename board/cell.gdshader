shader_type canvas_item;

uniform vec2 mouse_position = vec2(0);

void vertex() {
	if (mouse_position != vec2(0)) {
		vec2 vec_to_mouse = mouse_position - VERTEX;
		float dist_to_mouse = distance(mouse_position, VERTEX);
		vec_to_mouse *= 0.1 * dist_to_mouse;
		VERTEX -= vec_to_mouse * 0.1;
	}
}
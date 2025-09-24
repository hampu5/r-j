shader_type canvas_item;

uniform sampler2D screen_texture: hint_screen_texture;
uniform sampler2D palette: filter_nearest;
uniform int palette_size;

void fragment() {
	float alpha = COLOR.a;
	vec3 orig_color = texture(screen_texture, SCREEN_UV).rgb;
	vec3 mapped_color;
	float min_dist = 1e3;
	if (palette_size == 0) {
		discard;
	}
	for (int i = 1; i < palette_size + 1; i++) {
		vec3 palette_color = texture(palette, vec2(float(i) / float(palette_size), 0.5)).rgb;
		float dist = distance(orig_color, palette_color);
		if (dist < min_dist) {
			min_dist = dist;
			mapped_color = palette_color;
		}
	}
	COLOR.rgb = mapped_color.rgb;
	COLOR.a = alpha;
}
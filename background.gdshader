shader_type canvas_item;

uniform sampler2D noise: repeat_enable;
uniform float scroll_speed = 0.0;
uniform vec3 col1: source_color;
uniform vec3 col2: source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 uv = UV;
	uv.y = sin(0.01 * TIME);
	vec2 uv1 = uv;
	vec2 uv2 = uv;
	uv1.x += 1.5;
	vec4 noise_color1 = texture(noise, uv1 - 0.01 * (TIME + scroll_speed));
	vec4 noise_color2 = texture(noise, uv2 + 0.01 * (TIME + scroll_speed));

	//noise_color1.y = sin(TIME);

	//ALBEDO = mix(noise_color1.x * col1, noise_color2.x * col2, 0.5);
	vec4 blended_noise1 = mix(noise_color1, noise_color2, 0.5);
	COLOR.rgb = mix(col1, col2, blended_noise1.x);
	vec4 color = vec4(1);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}

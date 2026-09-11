shader_type canvas_item;

uniform sampler2D screen_tex : hint_screen_texture, filter_nearest;
uniform float color_crush : hint_range(1.0, 100.0, 1.0) = 1.0;
uniform vec2 gamma = vec2(1.0, 1.0);

void fragment() {
	vec4 screen = texture(screen_tex, SCREEN_UV);

	// Dithering / color crush
	screen.rgb = pow(screen.rgb, vec3(gamma.x));
	float greyscale = max(screen.r, max(screen.g, screen.b));
	float lower = floor(greyscale * color_crush) / color_crush;
	float higher = ceil(greyscale * color_crush) / color_crush;
	float lower_dif = abs(lower - greyscale);
	float higher_dif = abs(higher - greyscale);
	float color_level = lower_dif < higher_dif ? lower : higher;
	float final_crush = (greyscale > 0.0) ? (color_level / greyscale) : 0.0;
	screen.rgb *= final_crush;
	screen.rgb = pow(screen.rgb, vec3(gamma.y));

	COLOR = screen;
}
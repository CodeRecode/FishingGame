shader_type sky;
render_mode use_debanding;

uniform float hdri_strength : hint_range(0.0, 1.0, 0.1);
uniform vec3 hill_color : source_color;
uniform sampler2D sky_tex : filter_linear, source_color;
uniform sampler2D cloud_tex : filter_linear, source_color;

void sky() {
	if (AT_CUBEMAP_PASS) {
		COLOR = vec3(hdri_strength);
	}
	else {
		COLOR = mix(texture(sky_tex, SKY_COORDS).rgb, texture(cloud_tex, SKY_COORDS.xy).rgb, texture(cloud_tex, SKY_COORDS.xy).a * (0.7 - SKY_COORDS.y));
		if (SKY_COORDS.y + sin(SKY_COORDS.x * PI * 20.0) / 100.0 > .5) {
			COLOR = vec3(hill_color);
		}
	}
}

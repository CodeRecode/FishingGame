shader_type spatial;
render_mode blend_sub;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALBEDO = vec3(0.0);
	
	ALPHA = (.5 - distance(UV, vec2(0.5))) * 3.0;
}

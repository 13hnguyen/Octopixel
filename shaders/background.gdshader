shader_type canvas_item;

uniform vec2 size = vec2(10., 10.);

void fragment() {
	vec2 pos = floor(UV*size);
	float PatternMask = mod(pos.x + pos.y, 2.0);
	
	if (PatternMask == 0.)
		COLOR = vec4(1., 1., 1., 1.);
	else
		COLOR = vec4(.8, 0.8, 0.8, 1.);
}
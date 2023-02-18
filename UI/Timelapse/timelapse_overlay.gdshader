shader_type canvas_item;

uniform float speed = 1;

void fragment() {
	// Place fragment code here.
	vec2 uv = UV;
	uv.x += TIME * float(speed);
	vec4 col = texture(TEXTURE, uv);
	if(col.r == 1.0) {
		col.a *= 0.5;
	}
	COLOR = col;
}

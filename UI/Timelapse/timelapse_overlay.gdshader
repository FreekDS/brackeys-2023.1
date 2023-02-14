shader_type canvas_item;

uniform int speed = 1;

void fragment() {
	// Place fragment code here.
	vec2 uv = UV;
	uv.x += TIME * float(speed);
	vec4 col = texture(TEXTURE, uv);
	COLOR = col;
}

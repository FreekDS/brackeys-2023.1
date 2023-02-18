shader_type canvas_item;

uniform vec4 modulate : source_color;

void fragment() {
	vec2 uv = UV;
	uv.x += TIME * .02;
	vec4 col = texture(TEXTURE, uv);
	
	COLOR = col * modulate;
}

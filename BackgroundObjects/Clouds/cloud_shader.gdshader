shader_type canvas_item;

uniform sampler2D noise_texture;
uniform float cloudTreshold : hint_range(0.0, 1.0, 0.1) = .2;
uniform int pixelSize = 16;

void fragment() {
	// Place fragment code here.
	
	ivec2 size = textureSize(noise_texture, 0);
	
	int xRes = size.x;
	int yRes = size.y;
	
	float xFactor = float(xRes) / float(pixelSize);
	float yFactor = float(yRes) / float(pixelSize);
	
	float grid_uv_x = round(UV.x * xFactor) / xFactor;
	float grid_uv_y = round(UV.y * yFactor) / yFactor;
	vec2 at = vec2(grid_uv_x, grid_uv_y);
	
	float sample = texture(noise_texture, at).r;
	vec4 col = vec4(1.0,1.0,1.0,0.0);
	if(sample > cloudTreshold) {
		col.a = sample * 2.0;
	}
	COLOR = col;
}

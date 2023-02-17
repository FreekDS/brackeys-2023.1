shader_type canvas_item;

uniform float cloudTreshold : hint_range(0.0, 1.0, 0.1) = .4;
uniform float cloudDarkness : hint_range(0.0, 1.0, 0.1) = 1.0;
uniform int pixelSize = 1;
uniform vec2 direction;
uniform float speedMultiplier = .3;

void fragment() {
	// Place fragment code here.
	
	ivec2 size = textureSize(TEXTURE, 0);
	
	int xRes = size.x;
	int yRes = size.y;
	
	float xFactor = float(xRes) / float(pixelSize);
	float yFactor = float(yRes) / float(pixelSize);
	
	vec2 uv = UV + direction * TIME * speedMultiplier;
	
	float grid_uv_x = round(uv.x * xFactor) / xFactor;
	float grid_uv_y = round(uv.y * yFactor) / yFactor;
	vec2 at = vec2(grid_uv_x, grid_uv_y);
	
	float sample = texture(TEXTURE, at).r;
	vec4 col = vec4(cloudDarkness,cloudDarkness,cloudDarkness,0.0);
	if(sample > cloudTreshold) {
		col.a = abs(sample) * 1.3;
	}
	COLOR = col;
}

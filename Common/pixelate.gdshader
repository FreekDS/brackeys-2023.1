shader_type canvas_item;

uniform int pixelSize = 16;

void fragment() {
	// Place fragment code here.
	ivec2 size = textureSize(TEXTURE, 0);
	
	int xRes = size.x;
	int yRes = size.y;
	
	float xFactor = float(xRes) / float(pixelSize);
	float yFactor = float(yRes) / float(pixelSize);
	
	float grid_uv_x = round(UV.x * xFactor) / xFactor;
	float grid_uv_y = round(UV.y * yFactor) / yFactor;
	
	vec4 text = texture(TEXTURE, vec2(grid_uv_x, grid_uv_y));
	
	COLOR = text;
}

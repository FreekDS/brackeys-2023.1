shader_type canvas_item;
// https://www.shadertoy.com/view/fdGfRV
// https://www.pcg-random.org/
uint pcg(uint v)
{
	uint state = v * 747796405u + 2891336453u;
	uint word = ((state >> ((state >> 28u) + 4u)) ^ state) * 277803737u;
	return (word >> 22u) ^ word;
}



uvec2 pcg2d(uvec2 v)
{
    v = v * 1664525u + 1013904223u;

    v.x += v.y * 1664525u;
    v.y += v.x * 1664525u;

    v = v ^ (v>>16u);

    v.x += v.y * 1664525u;
    v.y += v.x * 1664525u;

    v = v ^ (v>>16u);

    return v;
}

// http://www.jcgt.org/published/0009/03/02/
uvec3 pcg3d(uvec3 v) {

    v = v * 1664525u + 1013904223u;

    v.x += v.y*v.z;
    v.y += v.z*v.x;
    v.z += v.x*v.y;

    v ^= v >> 16u;

    v.x += v.y*v.z;
    v.y += v.z*v.x;
    v.z += v.x*v.y;

    return v;
}

float HashToNoise1(uint hash)
{
    return float(hash % 65536u) / 65536.0;
}

vec2 HashToNoise2(uvec2 hash)
{
    return vec2(
        float(hash.x % 65536u) / 65536.0,
        float(hash.y % 65536u) / 65536.0
    );
}

vec3 HashToNoise3(uvec3 hash)
{
    return vec3(
        float(hash.x % 65536u) / 65536.0,
        float(hash.y % 65536u) / 65536.0,
        float(hash.z % 65536u) / 65536.0
    );
}

mat2 RotationMatrix(float theta)
{
    float s = sin(theta);
    float c = cos(theta);
	return mat2(vec2(c, -s),vec2( s, c));
}

vec4 GetRainLayer(vec2 uv, float layerScale, float layerIntensity, float layerBlueShift, uint viewType)
{
    uvec2 rc = uvec2(uv * vec2(50.0, 10.0) * layerScale);
    float colNoise0 = HashToNoise1(pcg(rc.x));
    
    // Random speed and drop length
    float rainFallDist = (colNoise0 * 2.0 + TIME * 5.0 * (layerScale * 0.9 + 0.1));
    float heightScale = (colNoise0 * 3.0 + 5.0) * layerScale;
    
    rc.y = uint(uv.y * heightScale + rainFallDist);
    float rowNoise0 = HashToNoise1(pcg(rc.y));
    vec2 cellNoise0 = HashToNoise2(pcg2d(rc));
    
    // Local coords within cell
    vec2 f = fract(uv * vec2(50.0, heightScale) + vec2(0.0, rainFallDist));
    f.y = 1.0 - f.y;
    
    // Shift drop left or right
    float xOffset = (rowNoise0 * 2.0 - 1.0) * 0.4;
    
    vec2 sdf = vec2(abs((f.x + xOffset) * 2.0 - 1.0), f.y);
    
    float dropVisibility = cellNoise0.x;
    float v = max(0.0, 1.0 - sdf.x * 3.0) * f.y * dropVisibility * layerIntensity;
    
    if (viewType == 2u)
        return vec4(cellNoise0.x);
    else
        return vec4(mix(vec3(1.0), vec3(0.2, 0.5, 1.0), layerBlueShift) * v, v);
}

void fragment()
{
    // Divide screen into different views
    uint viewType;
    
    viewType = 0u;
    
    vec4 c = vec4(0.0);
    float layerThetaOffset = -0.08; // Global rotation for all layers
    
    uint layerCt = (viewType == 1u) ? 25u : 1u;
    for (uint i = 0u; i < layerCt; ++i)
    {
        // Setup layer properties
        float layerNoise0 = HashToNoise1(pcg(i));
        float layerTheta = (layerNoise0 * 2.0 - 1.0) * 0.011 + layerThetaOffset; // Random theta per layer
        vec2 layerUv = UV * RotationMatrix(layerTheta);
        
        // Farther raindrops should be smaller, less intense, and bluer
        float layerScale = sqrt(float(i) * 0.25 + 1.0);
        float layerIntensity = exp(-float(i + 1u) * 0.235);
        float layerBlueShift = 1.0 - exp(-float(i + 1u) * 0.25);
        
        c += (1.0 - c.a) * GetRainLayer(layerUv + float(i) * vec2(223.32849, 432.3829), layerScale, layerIntensity, layerBlueShift, viewType);
    }

    // Output to screen
    COLOR = vec4(c.rgb, 0.5);
}

uniform float bloomRadius = 1.0;
uniform float bloomThreshold = 1.0;
uniform float bloomIntensity = 1.0;

vec3 GetBloomPixel(sampler2D tex, vec2 uv, vec2 texPixelSize) {
	vec2 uv2 = floor(uv / texPixelSize) * texPixelSize;
	uv2 += texPixelSize * .001;
	vec3 tl = max(texture(tex, uv2).rgb - bloomThreshold, 0.0);
	vec3 tr = max(texture(tex, uv2 + vec2(texPixelSize.x, 0.0)).rgb - bloomThreshold, 0.0);
	vec3 bl = max(texture(tex, uv2 + vec2(0.0, texPixelSize.y)).rgb - bloomThreshold, 0.0);
	vec3 br = max(texture(tex, uv2 + vec2(texPixelSize.x, texPixelSize.y)).rgb - bloomThreshold, 0.0);
	vec2 f = fract( uv / texPixelSize );

	vec3 tA = mix( tl, tr, f.x );
	vec3 tB = mix( bl, br, f.x );

	return mix( tA, tB, f.y );
}

vec3 applyGaussianBlur(sampler2D tex, vec2 uv, vec2 texPixelSize, float blurScale) {
    float weights[9] = float[](0.000229, 0.005977, 0.060598, 0.241732, 0.382928, 0.241732, 0.060598, 0.005977, 0.000229);
    vec3 color = texture(tex, uv).rgb * weights[4]; // Center weight
    for (int i = 1; i <= 4; ++i) {
        float ii = float(i) * blurScale; // Multiply the index by the blur scale
        color += texture(tex, uv + vec2(texPixelSize.x * ii, 0.0)).rgb * weights[4 + i];
        color += texture(tex, uv - vec2(texPixelSize.x * ii, 0.0)).rgb * weights[4 - i];
        color += texture(tex, uv + vec2(0.0, texPixelSize.y * ii)).rgb * weights[4 + i];
        color += texture(tex, uv - vec2(0.0, texPixelSize.y * ii)).rgb * weights[4 - i];
    }
    return color;
}

vec3 GetBloom(sampler2D tex, vec2 uv, vec2 texPixelSize) {
    vec3 bloom = applyGaussianBlur(tex, uv, texPixelSize, bloomRadius);
    return bloom;
}

float softLight(float a, float b) {
    return (b < 0.5) ? (2.0*a*b + a*a*(1.0 - 2.0*b)) : (sqrt(a)*(2.0*b - 1.0) + 2.0*a*(1.0 - b));
}

vec3 softLightVec(vec3 a, vec3 b) {
    return vec3(softLight(a.r, b.r), softLight(a.g, b.g), softLight(a.b, b.b));
}

void fragment() {
    vec4 col = texture(TEXTURE, UV);
    vec3 bloom = GetBloom(TEXTURE, UV, TEXTURE_PIXEL_SIZE);
    bloom *= bloomIntensity;
    col.rgb = col.rgb + softLightVec(col.rgb, bloom);
    COLOR = col;
}

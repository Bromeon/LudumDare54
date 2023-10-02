shader_type canvas_item;

uniform float bloomRadius = 2.0;

uniform float level1Scale = 1.0;
uniform float level2Scale = 2.9;
uniform float level3Scale = 5.49;
uniform float level4Scale = 0.18;
uniform float level5Scale = 0.4;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

float softLight(float a, float b) {
    return (1.0 - 2.0 * b) * a * a + 2.0 * b * a;
}

vec3 softLightVec(vec3 a, vec3 b) {
    return vec3(softLight(a.r, b.r), softLight(a.g, b.g), softLight(a.b, b.b));
}

void fragment() {
    //vec4 blurry_color = textureLod(screen_texture, SCREEN_UV, bloomRadius);
    
    vec4 level1 = textureLod(screen_texture, SCREEN_UV, 1.0) * level1Scale;
    vec4 level2 = textureLod(screen_texture, SCREEN_UV, 2.0) * level2Scale;
    vec4 level3 = textureLod(screen_texture, SCREEN_UV, 3.0) * level3Scale;
    vec4 level4 = textureLod(screen_texture, SCREEN_UV, 4.0) * level4Scale;
    vec4 level5 = textureLod(screen_texture, SCREEN_UV, 5.0) * level5Scale;
    
    vec3 blurry_color = max(level1.rgb, level2.rgb);
    blurry_color = max(level2.rgb, level3.rgb);
    blurry_color = max(blurry_color.rgb, level4.rgb);
    blurry_color = max(blurry_color.rgb, level5.rgb);
    
	vec4 color = texture(screen_texture, SCREEN_UV);
	COLOR.rgb = softLightVec(color.rgb, blurry_color.rgb);
}
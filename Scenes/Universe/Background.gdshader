// A shader to show a space background with 4 layers of parallax
shader_type canvas_item;

uniform sampler2D backgroundTex : filter_nearest, repeat_enable;
uniform sampler2D nebulaTex : filter_nearest, repeat_enable;
uniform sampler2D planetsTex : filter_nearest, repeat_enable;
uniform sampler2D starsTex : filter_nearest, repeat_enable;

uniform float backgroundSpeed;
uniform float nebulaSpeed;
uniform float starsSpeed;
uniform float planetsSpeed;

uniform float zoom;
uniform float brightness;

uniform vec2 offset;

void fragment()
{
    vec2 uv = UV * zoom;

    vec4 background = texture(backgroundTex, uv + offset * backgroundSpeed);
    vec4 nebula = texture(nebulaTex, uv + offset * nebulaSpeed);
    vec4 stars = texture(starsTex, uv + offset * starsSpeed);
    vec4 planets = texture(planetsTex, uv + offset * planetsSpeed);
	
	vec4 color = background;
	color = mix(color, nebula, nebula.a);
	color = mix(color, stars, stars.a);
	color = mix(color, planets, planets.a);
	
	color = mix(color, vec4(0,0,0,1), 1.0 - brightness);

    COLOR = color;
}
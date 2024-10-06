shader_type canvas_item;

//uniform vec4 color : source_color = vec4(1);
uniform float thickness : hint_range(0.0, 108., 0.1) = 5.;
uniform int spikes : hint_range(1,20, 1) = 8;
uniform int strands: hint_range(1, 20, 1) = 3;
uniform float indencity : hint_range(0.000, .5, 0.001) = 0.1;
uniform vec2 center = vec2(.5,.5);
uniform float rel_size : hint_range(0., 1., .1) = 0.5;
uniform vec2 skew = vec2(1., 1.);

uniform float influence: hint_range(0.0, 1.0, 0.1) = 1.0;
uniform float offset: hint_range(0.0, 360.0, 1.0);

uniform float cutout: hint_range(0.0, 1.0, 0.01) = 0.20;

const float TWO_PI = 6.28318530718;

vec3 hsv2rgb(vec3 _c) {
    vec4 _K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 _p = abs(fract(_c.xxx + _K.xyz) * 6.0 - _K.www);
    return _c.z * mix(_K.xxx, clamp(_p - _K.xxx, 0.0, 1.0), _c.y);
}

void fragment() {
	//COLOR.rgb = color.rgb;
	float angle = atan(UV.y-center.y, UV.x-center.x);
	float r = sqrt(pow(UV.x - center.x,2)/skew.x + pow(UV.y - center.y, 2)/skew.y);
	float indent_fix = (.3)*r*float(strands);
	float b =  (r + indencity*abs(sin(angle*float(spikes)/2.0))*indent_fix);
	float a = fract(float(strands) * b / rel_size);
	
	vec2 pos = vec2(0.5) - UV;
	COLOR.rgb = influence * hsv2rgb(vec3(((atan(pos.y, pos.x) + radians(offset)) / TWO_PI) + 0.5, length(pos) * 2.0, 1.0));
	
	COLOR.a = min(
				max(smoothstep(1.-thickness*.1, 1., a), 
	              smoothstep(thickness*.1/(20.*r +.01), 0.0, abs(sin(angle*float(spikes)/2.0)))),
				1. - step(0., b - rel_size));
}
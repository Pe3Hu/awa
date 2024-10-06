shader_type canvas_item;

uniform int n : hint_range(3,20, 1) = 8;
uniform int k : hint_range(1,5, 1) = 2;
uniform float l : hint_range(0.1,0.5, 0.01) = 0.5;
uniform float offset: hint_range(0.0, 360.0, 1.0) = 180.;

float line( vec2 p, vec2 a, vec2 b )
{
	vec2 pa = p-a, ba = b-a;
	float h = clamp( dot(pa,ba)/dot(ba,ba), 0.0, 1.0 );
    vec2  d = pa - ba*h;
	return dot(d,d);
}

vec3 hsv2rgb(vec3 _c) {
    vec4 _K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 _p = abs(fract(_c.xxx + _K.xyz) * 6.0 - _K.www);
    return _c.z * mix(_K.xxx, clamp(_p - _K.xxx, 0.0, 1.0), _c.y);
}

void fragment() {
	float t = 0.01; //thickness
	vec2 p = UV - vec2(.5);
	
	vec2 d = vec2(1.0);
	float angle = PI * 2. / float(n);
	float part_l = l / float(k);
	vec2 vertices[200];
	
	for( int i=0; i < k; i++ )
	{
		for( int j=0; j < n; j++ )
		{
			vec2 a = vec2(sin(angle * float(j)), cos(angle * float(j))) * part_l * float(i + 1);
			vertices[i * n + j] = a;
			
			if (i == k - 1)
				d = min( d, vec2(line( p,a,vec2(0.0) ) ) );
		}
	}
		
	
	for( int i=0; i < k; i++ )
	{
		for( int j=0; j < n; j++ ){
			int m = i * n + (j + 1) % n;
			vec2 a = vertices[i * n + j];
			vec2 b = vertices[m];
			d = min( d, vec2(line( p,a,b ) ) );
		}
	}
	
	COLOR.rgb = hsv2rgb(vec3(((atan(p.y, p.x) + radians(offset / 1.)) / PI * .5) + 0.5, length(p) * 2.0, 1.0));
	d = sqrt(d); //make octagon
	vec4 color = vec4(COLOR.rgb, 0.0);
	color = mix( color, vec4(COLOR.rgb,1.), 1.0-smoothstep(0.0,t,d.x) );  
	COLOR = vec4(color); //final image
}
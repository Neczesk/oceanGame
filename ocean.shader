shader_type spatial;


float wave(vec3 pos, float time, vec2 Di, float Wl, float Amp, float Sp){
	Sp = Sp * 2.0/Wl;
	float w = 2.0 / Wl;
	float d1 = dot(pos.xz, Di);
	float t1 = d1 * w;
	float t2 = time * Sp;
	float inner = t1 + t2;
	return Amp * sin(inner);
}

vec3 wave_normal(vec3 pos, float time, vec2 Di, float Wl, float Amp, float Sp){
	Sp = Sp * 2.0/Wl;
	float w = 2.0/Wl;
	float outer = w * Di.x * Amp;
	float inner = dot(Di, pos.xz) * w + (time * Sp);
	float partial_x = cos(inner) * outer;
	outer = Wl * Di.y * Amp;
	float partial_y = cos(inner) * outer;
	return vec3(-partial_x, 1.0, -partial_y);
	
}


void vertex(){
	float wave1 = wave(VERTEX, TIME, vec2(0.1, 0.4), 8, 0.5, 1);
	float wave2 = wave(VERTEX, TIME, vec2(-0.6, 0.2), 4, 1, 1);
	float wave3 = wave(VERTEX, TIME, vec2(0.3, -0.7), 2, 2, 0.5);
	VERTEX.y += wave1 + wave2 + wave3;

	vec3 wave_normal1 = wave_normal(VERTEX, TIME, vec2(0.1, 0.4), 8, 0.5, 1);
	vec3 wave_normal2 = wave_normal(VERTEX, TIME, vec2(-0.6, 0.2), 4, 1, 1);
	vec3 wave_normal3 = wave_normal(VERTEX, TIME, vec2(0.3, -0.7), 2, 2, 0.5);
	NORMAL = normalize(wave_normal1 + wave_normal2 +wave_normal3);
//	NORMAL = normalize(vec3(k - height(VERTEX.xz + vec2(0.1, 0.0), TIME), 0.1, k - height(VERTEX.xz + vec2(0.0, 0.1), TIME)));

}


void fragment(){
	RIM = 0.1;
//	METALLIC = 0.0;
	ROUGHNESS = 0.01;
	ALBEDO = vec3(0.1,0.2,0.3);
}

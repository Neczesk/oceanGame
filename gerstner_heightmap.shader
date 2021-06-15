shader_type spatial;
render_mode specular_toon;

uniform float Q = 0.2;
//uniform int num_waves = 15;

//each wave gets an array
//In order: wavelength, amplitude, direction.x, direction.y
uniform vec4 wave_0 = vec4(30.204023, 1.812241, 0.456148, 0.60986);
uniform vec4 wave_1 = vec4(27.422121, 1.645327, -0.184917, 0.738787);
uniform vec4 wave_2 = vec4(39.679749, 2.380785, 0.76153, -0.008503);
uniform vec4 wave_3 = vec4(34.826313, 2.089579, 0.733377, -0.205326);
uniform vec4 wave_4 = vec4(34.387756, 2.063265, 0.746639, -0.150098);
uniform vec4 wave_5 = vec4(19.181908, 1.150915, 0.608518, -0.457937);
uniform vec4 wave_6 = vec4(14.437761, 0.866266, 0.758792, 0.065079);
uniform vec4 wave_7 = vec4(18.730997, 1.12386, 0.506575, 0.568667);
uniform vec4 wave_8 = vec4(14.588003, 0.87528, 0.638712, -0.414786);
uniform vec4 wave_9 = vec4(15.42426, 0.925456, -0.713352, -0.266701);
uniform vec4 wave_10 = vec4(3.548167, 0.21289, -0.066858, 0.758637);
uniform vec4 wave_11 = vec4(2.869323, 0.172159, -0.570269, 0.50477);
uniform vec4 wave_12 = vec4(3.666171, 0.21997, -0.751441, 0.123839);
uniform vec4 wave_13 = vec4(3.752006, 0.22512, -0.416022, -0.637907);
uniform vec4 wave_14 = vec4(2.995751, 0.179745, -0.428207, 0.629793);

const float PI = 3.14159265358979323846;
const float twoPI = PI*2.0;


float wavex(vec2 hpos, float time, vec2 Di, float w, float Amp, float Sp, float Qi){
	float cosineTerm = dot((w*Di), hpos.xy) + (Sp * time);
	return (Qi*Amp) * Di.x * cos(cosineTerm);
}

float wavez(vec2 hpos, float time, vec2 Di, float w, float Amp, float Sp, float Qi){
	float cosineTerm = dot((w*Di), hpos.xy) + (Sp * time);
	return (Qi*Amp) * Di.y * cos(cosineTerm);
}

float wave_height(vec4 wave_vec, float time, vec2 hpos){
	float speed = sqrt(9.8 * twoPI/wave_vec[0]);
	float w = 2.0 / wave_vec[0];
	return wave_vec[1] * sin(dot(w*vec2(wave_vec[2], wave_vec[3]), hpos) + (speed*time));
	
}

vec3 wave_iter(vec4 wave_vec, float time, vec2 hpos){
	float speed = sqrt(9.8 * twoPI/wave_vec[0]);
	float w = 2.0 / wave_vec[0];
	//float Qi = Q / (w * wave_vec[1] * 15.0);
	float Qi = Q;
	vec2 Di = vec2(wave_vec[2], wave_vec[3]);
	float x = wavex(hpos, time, Di, w, wave_vec[1], speed, Qi);
	float z = wavez(hpos, time, Di, w, wave_vec[1], speed, Qi);
	float y = wave_height(wave_vec, time, hpos);
	return vec3(x,y,z);
	
}

vec3 wave(vec3 pos, float time){
	vec3 waves[15] = vec3[15];
	waves[0] = wave_iter(wave_0, time, pos.xz);
	waves[1] = wave_iter(wave_1, time, pos.xz);
	waves[2] = wave_iter(wave_2, time, pos.xz);
	waves[3] = wave_iter(wave_3, time, pos.xz);
	waves[4] = wave_iter(wave_4, time, pos.xz);
	waves[5] = wave_iter(wave_5, time, pos.xz);
	waves[6] = wave_iter(wave_6, time, pos.xz);
	waves[7] = wave_iter(wave_7, time, pos.xz);
	waves[8] = wave_iter(wave_8, time, pos.xz);
	waves[9] = wave_iter(wave_9, time, pos.xz);
	waves[10] = wave_iter(wave_10, time, pos.xz);
	waves[11] = wave_iter(wave_11, time, pos.xz);
	waves[12] = wave_iter(wave_12, time, pos.xz);
	waves[13] = wave_iter(wave_13, time, pos.xz);
	waves[14] = wave_iter(wave_14, time, pos.xz);
	vec3 output = vec3(0.0,0.0,0.0);
	for (int i = 0; i < 15; i++){
		output += waves[i];
	}
	output[0] += pos.x;
	output[2] += pos.z;
	return output;
}

float normal_sine(float w, vec2 Di, vec2 hpos, float Sp, float time){
	return sin(w * dot(Di, hpos) + (Sp * time));
}

float normal_cos(float w, vec2 Di, vec2 hpos, float Sp, float time){
	return cos(w * dot(Di, hpos) + (Sp * time));
}

vec3 wave_normal_iter(vec4 wave_vec, vec2 hpos, float time){
	float w = 2.0 / wave_vec[0];
	float speed = sqrt(9.8 * twoPI/wave_vec[0]);
	vec2 Di = vec2(wave_vec[2], wave_vec[3]);
	//float Qi = Q / (w * wave_vec[1] * 15.0);
	float Qi = Q;
	float x = wave_vec[2] * (w * wave_vec[1]) * normal_cos(w,Di, hpos, speed, time);
	float z = wave_vec[3] * (w * wave_vec[1]) * normal_cos(w, Di, hpos, speed, time);
	float height = Qi * (w* wave_vec[1]) * normal_sine(w, Di, hpos, speed, time);
	return vec3(x, height, z);
}

vec3 wave_normal(vec3 pos, float time){
	vec3 waves[15] = vec3[15];
	waves[0] = wave_normal_iter(wave_0, pos.xz, time);
	waves[1] = wave_normal_iter(wave_1, pos.xz, time);
	waves[2] = wave_normal_iter(wave_2, pos.xz, time);
	waves[3] = wave_normal_iter(wave_3, pos.xz, time);
	waves[4] = wave_normal_iter(wave_4, pos.xz, time);
	waves[5] = wave_normal_iter(wave_5, pos.xz, time);
	waves[6] = wave_normal_iter(wave_6, pos.xz, time);
	waves[7] = wave_normal_iter(wave_7, pos.xz, time);
	waves[8] = wave_normal_iter(wave_8, pos.xz, time);
	waves[9] = wave_normal_iter(wave_9, pos.xz, time);
	waves[10] = wave_normal_iter(wave_10, pos.xz, time);
	waves[11] = wave_normal_iter(wave_11, pos.xz, time);
	waves[12] = wave_normal_iter(wave_12, pos.xz, time);
	waves[13] = wave_normal_iter(wave_13, pos.xz, time);
	waves[14] = wave_normal_iter(wave_14, pos.xz, time);
	vec3 output = vec3(0.0,0.0,0.0);
	for (int i = 0; i < 15; i++){
		output += waves[i];
	}
	output[0] *= -1.0;
	output[1] = 1.0 - output[1];
	output[2] *= -1.0;
	return output;
	
}


void vertex(){
	VERTEX = wave(VERTEX, TIME);
	NORMAL = wave_normal(VERTEX, TIME);
}


void fragment(){
	float fresnel = sqrt(1.0 - dot(NORMAL, VIEW));
	RIM = 0.1;
	METALLIC = 0.0;
	ROUGHNESS = 0.01 * (1.0 - fresnel);
	ALBEDO = vec3(0.1,0.2,0.3) + (0.1 * fresnel);
}

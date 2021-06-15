extends MeshInstance


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


#export var wind_direction: Vector2 = Vector2(0.5,0.7) setget set_wind_direction
#export var wind_strength: float = 13.4 setget set_wind_strength
export var wave_Q: float = 0.2 setget set_wave_Q
var med_wave_height: float = 2.0535
var med_wavelength: float = 34.225
var med_wave_direction: Vector2 = Vector2(0.3, 0.7)

func set_wind(strength:float, direction: Vector2):
	med_wave_height = pow(strength, 2) * 0.0015
	med_wavelength = pow(strength, 2) * 0.025
	med_wave_direction = direction
#	print("Wind set on Ocean")
	generate_waves()

#func set_wind_strength(new_wind_strength):
#	wind_strength = new_wind_strength
#	generate_waves()
#
#func set_wind_direction(new_wind_direction):
#	wind_direction = new_wind_direction
#	print("wind_direction changed")
#	generate_waves()

func set_wave_Q(new_Q: float):
	set_Q(new_Q)
	
func set_Q(new_Q: float):
#	print("old q = " + String(wave_Q))
	wave_Q = clamp(new_Q, 0.0, 0.99)
#	print("Q changed to: " + String(wave_Q))
	self.get_active_material(0).set_shader_param("Q", wave_Q)


var waves: Array = []


func generate_waves():
#	var median_wave_height = pow(wind_strength, 2) * 0.0015
#	var median_wavelength = pow(wind_strength, 2) * 0.025
	check_parameter_equality()
	var file = File.new()
	file.open("res://shader_defaults.txt", File.WRITE)


	for i in range(0, 5):
		waves.append(new_wave(med_wave_height, med_wavelength, i))
		var param_string = "wave_" + String(i)
		self.get_active_material(0).set_shader_param(param_string, waves[i])
		var default_line = "uniform vec4 " + param_string + " = vec4(" + String(waves[i]) + ");\n"
		file.store_string(default_line)

	for i in range(5, 10):
		waves.append(new_wave(med_wave_height*0.5, med_wavelength*0.5, i))
		var param_string = "wave_" + String(i)
		self.get_active_material(0).set_shader_param(param_string, waves[i])
		var default_line = "uniform vec4 " + param_string + " = vec4(" + String(waves[i]) + ");\n"
		file.store_string(default_line)

	for i in range(10, 15):
		waves.append(new_wave(med_wave_height*0.1, med_wavelength*0.1, i))
		var param_string = "wave_" + String(i)
		self.get_active_material(0).set_shader_param(param_string, waves[i])
		var default_line = "uniform vec4 " + param_string + " = vec4(" + String(waves[i]) + ");\n"
		file.store_string(default_line)

	file.close()
	

func new_wave(median_height: float, median_length: float, wave_number: int) -> Plane:
	randomize()
	var median_ratio = median_height/median_length

	var wavelength = median_length * rand_range(0.8,1.2)
	var wave_height = median_ratio * wavelength
	var wave_direction = med_wave_direction.rotated(rand_range(-PI/median_height, PI/median_height))
	var frequency = 2.0 / wavelength
#	print(frequency)
#	print("Qi = " + String(wave_Q/(frequency * wave_height * 15)))
	return Plane(wavelength,wave_height,wave_direction.x,wave_direction.y)

# Called when the node enters the scene tree for the first time.
func _ready():
#	set_n_waves(num_waves)
#	set_Q(wave_Q)

#	print(self.get_active_material(0).get_shader_param("Q"))
#	print(self.get_active_material(0).get_shader_param("num_waves"))
#	set_num_waves(15)
#	check_parameter_equality()
#	print("old waves")
#	print_waves()
#	generate_waves()
#	for i in range(0, 15):
#		waves[i] = Color(0,0,0,0)
#	check_wave_equality()
	
#	check_parameter_equality()
#	print("new waves")
#	print_waves()

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func print_waves():
	for i in range(0,15):
		var param_string = "wave_" + String(i)
		print(self.get_active_material(0).get_shader_param(param_string))
		
func check_parameter_equality():
	if self.get_active_material(0).get_shader_param("Q") != wave_Q:
		print("Q is not the same as wave_q")
		
func check_wave_equality():
	for i in range(0,15):
		var script_wave = waves[i]
		var param_string = "wave_" + String(i)
		var shader_wave = self.get_active_material(0).get_shader_param(param_string)
#		print(script_wave)
#		print(shader_wave)
		if not shader_wave.is_equal_approx(script_wave):
			print("waves aren't the same")

func _on_Timer_timeout():
	pass
	
func get_height_at_point(hpos: Vector2) -> float:
	var output = 0.0
	for wave in waves:
		output += wave_height(wave, OS.get_ticks_msec(), hpos)
	return output
	
func wave_height(wave_vec: Plane, time: float, hpos: Vector2) -> float:
	var speed: float = sqrt(9.8 * (TAU/wave_vec.x))
	var w = 2.0 / wave_vec.x
	var dot = hpos.dot(w*Vector2(wave_vec.z, wave_vec.d))
	return wave_vec.y * sin(dot + (speed * time))

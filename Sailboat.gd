extends RigidBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var distance_from_water_level:float = 0.0
var waterlevel: float 
var wind_strength: float
var wind_direction: Vector2

var sail_level: float = 0 setget set_sail_level
var rudder_power: float = 100

func set_sail_level(new_sail: float):
	new_sail = clamp(new_sail, 0, 100)
	sail_level = new_sail
	



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _integrate_forces(state):
	add_central_force(Vector3(0,(distance_from_water_level + 1) * 9.8, 0))
	var forward: Vector3 = -transform.basis.z
	var wind3 = Vector3(wind_direction.x, 0, wind_direction.y)
	forward *= wind_strength * 0.4
#	print(forward.dot(wind3))
	forward *= max(forward.dot(wind3)+1,0.4)

	forward *= (1 * sail_level)
#	print(forward.normalized())
#	print(forward)
#	print(Vector2(self.rotation.x, self.rotation.z).dot(wind_direction))
#	print(forward)
	add_central_force(forward)
	add_central_force(weight * Vector3.UP)
	
	if Input.is_action_pressed("steer_left"):
		add_torque(Vector3(0,1,0) * rudder_power)
	if Input.is_action_pressed("steer_right"):
		add_torque(Vector3(0,-1,0) * rudder_power)
	if Input.is_action_pressed("add_sail"):
		set_sail_level(sail_level+1)
	if Input.is_action_pressed("remove_sail"):
		set_sail_level(sail_level-1)

extends RigidBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var distance_from_water_level:float = 0.0
var waterlevel: float


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _integrate_forces(state):
	add_central_force(Vector3(0,(distance_from_water_level + 1) * 9.8, 0))

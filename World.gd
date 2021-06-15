extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var wind_strength: float = 13.4 setget set_wind_strength
export var wind_direction: Vector2 = Vector2(0.3, 0.7) setget set_wind_direction

#This function deliberately does nothing. Use set_wind() instead
func set_wind_strength(new_wind_strength: float):
	pass
	
#This function deliberately does nothing. Use set_wind() instead
func set_wind_direction(_new_direction):
	pass
	
func set_wind(strength: float, direction: Vector2):
	wind_strength = strength
	wind_direction = direction
	$Ocean.set_wind(wind_strength, wind_direction)



# Called when the node enters the scene tree for the first time.
func _ready():
	set_wind(50, Vector2(0.3,0.7))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	for child in get_children():
		if child is RigidBody:
			if "distance_from_water_level" in child:
				child.distance_from_water_level = $Ocean.get_height_at_point(Vector2(child.global_transform.origin.x, child.transform.origin.z)) - child.transform.origin.y
			
	

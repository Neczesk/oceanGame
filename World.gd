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
	set_wind(13.4, Vector2(0.3,0.7))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

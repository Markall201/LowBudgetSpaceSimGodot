@tool
extends Resource
class_name AsteroidData

# basic settings
@export var seed: int = 0

@export var radius: float = 1
	#set(val):
	#	set_radius(val)
@export var height_multiplier = 0.05

@export var resolution: int = 64

@export var amplitude: float = 1.0

# setter
##func set_radius(val):
	#radius = val
#	emit_signal("changed")
	
# setter
#func set_height_multiplier(val):
	#height_multiplier = val
#	emit_signal("changed")

# geo settings
# for asteroids we use Perlin noise through FastNoiseLite
@export var height_map: FastNoiseLite

#setter for the seed
func set_seed(val: int):
	seed = val
	height_map.set_seed(seed)


# colour settings

@tool
extends Resource
class_name PlanetNoise

# multiple NoiseLayers let us define more granular noise by multiple functions at once.

@export var min_height: float = 1.0:
	set(val):
		min_height = val
		emit_signal("changed")



@export var amplitude: float = 1.0:
	set(val):
		amplitude = val
		emit_signal("changed")


# geo settings
@export var height_map: FastNoiseLite:
	set(val):
		height_map = val
		emit_signal("changed")
		
# using the first layer as the mask lets us add more details to areas the first layer
# has created, e.g. adding mountains to continents
@export var use_first_layer_as_mask: bool:
	set(val):
		use_first_layer_as_mask = val
		emit_signal("changed")

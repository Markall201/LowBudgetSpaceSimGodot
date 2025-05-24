@tool
extends Resource
class_name PlanetData

# high-level data 
@export var name: String

# enum definitions
# these could be used to determine lower-level planet properties e.g. terrain
enum PlanetType {
	Terrestrial, Desert, Oceanic, Jungle, Lava, Rocky, Ice, Gas}

enum TerrainColour {
	Terrestrial, Arid, Sand, Ice, Lush}
	
enum AtmosphereType {
	None, Terrestrial, Thin, Sulphurous, Red, Neon}
	
@export var planet_type: PlanetType

@export var terrain_colour: TerrainColour

@export var atmosphere_type: AtmosphereType


# basic settings
# the setters are primarily for making the planet change in the editor
@export var seed: int = 0:
	set(val):
		seed = val
		# set the seed for all noise layers
		for n in planet_noise:
				if n != null and n.height_map != null:
					n.height_map.set_seed(val)
					print(n.height_map.get_seed())
					if not n.is_connected("changed", on_data_changed):
						n.connect("changed", on_data_changed)
					
		emit_signal("changed")
		
@export var resolution: int = 256:
	# For LOD, the setter should only update the resolution if it needs updated
	# to avoid it changing every frame
	set(val):
		if (resolution != val):
			resolution = val
			emit_signal("changed")
			
@export var LODCurve: Curve

@export var radius: int = 1:
	set(val):
		radius = val
		emit_signal("changed")
		

# so instead of doing a single noise map,
# we'll do an array of noise layers so as to speak
# so the min_height, amplitude and height_map are all governed by PlanetNoise now.
# again, the complicated setter is just for changing the values in the editor
@export var planet_noise: Array[PlanetNoise]:
	set(val):
			planet_noise = val
			emit_changed()
			for n in planet_noise:
				if n != null and n.height_map != null and not n.is_connected("changed", on_data_changed):
					n.connect("changed", on_data_changed)
				
					
# colour settings - what colour shading to use
@export var planet_colour: GradientTexture1D:
	set(val):
		planet_colour = val
		emit_changed()
		
# colour settings - what colour shading to use
@export var planet_material: ShaderMaterial:
	set(val):
		planet_material = val
		emit_changed()
		
					
# min and max height are set in mesh generation, and are used for colour shading in the shader
var min_height: float
var max_height: float
					
					
func on_data_changed():
		emit_changed()

func _ready():
	#height_map.set_seed(seed)
	pass
	
# dictionary converter function
func to_dictionary():
	var planet_dictionary = {"name": name, "seed": seed, "radius": radius, "planet_type": planet_type, "terrain_colour": terrain_colour, "atmosphere_type": atmosphere_type}
	return planet_dictionary

# string converter
func _to_string():
	return seed

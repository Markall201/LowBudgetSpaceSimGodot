@tool
extends Node3D
class_name Planet


	
@export var planet_data:PlanetData:
	set(val):
		planet_data = val
		if planet_data != null and not planet_data.is_connected("changed", on_data_changed):
			planet_data.connect("changed", on_data_changed)


@export var player:Node3D
@export var distanceToPlayer: float

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/Node3D/PlayerShip")
	#print(player)
	on_data_changed()
	



func setLODByPlayerDistance(delta):
	if (player != null):
		distanceToPlayer = getDistanceToPlayer()
		
		
		# dole MK1 LOD system
		#if (distanceToPlayer <= (10 * planet_data.radius)):
			# call setter
		#	planet_data.set("resolution", 30)
		#else:
			# call setter
		#	planet_data.set("resolution", 3)
		
		# convert distance to player into an input for the LOD curve lookup
		var distanceToPlayer_LODInput: float = clampf(distanceToPlayer/(15 * planet_data.radius), 0.0, 1.0)
		# get the output from the LOD curve
		var newResolution: int = round(planet_data.LODCurve.sample(distanceToPlayer_LODInput))
		
		# print the details
		#print("distance to player: "+str(distanceToPlayer))
		#print("LODInput: "+str(distanceToPlayer_LODInput))
		#print("new resolution:" +str(newResolution))
		# reset the resolution - the setter's designed not to update unless the value's different
		planet_data.set("resolution", newResolution)
		
func getDistanceToPlayer():
	var distanceToPlayer: float = global_transform.origin.distance_to(player.global_transform.origin)
	return distanceToPlayer
	
	
# 	Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	setLODByPlayerDistance(delta)
	
# method to regenerate the planet from planet data
func on_data_changed():
	# reset min and max height - used for colour shading
	planet_data.min_height = 9999.0
	planet_data.max_height = 0.0
	# validation - if we have workable terrain data
	if (planet_data.planet_noise.size() > 0 and planet_data.planet_noise[0].height_map != null):
		# iterate over the child objects
		for child in get_children():
			# particularly concerned with TerrainFaces
			var face := child as TerrainFace
			if face is TerrainFace:

				face.construct_mesh(planet_data)
				face.update_textures(planet_data)
				
# dictionary converter function
func to_dictionary():
	return planet_data.to_dictionary()
	
# string converter function
func _to_string():
	return planet_data._to_string()
			
			
# Constructor equivalent - returns a new instance of the planet
# currently not used but working on it
# mirrors the to_dictionary() data from PlanetData
static func new_planet(name: String, seed: int, radius: int, planet_type: PlanetData.PlanetType, terrain_colour: PlanetData.TerrainColour, atmosphere_type: PlanetData.AtmosphereType) -> Planet:
	# load the prefab
	var planet_prefab: PackedScene = load("res://planet.tscn")
	# instantiate the prefab
	var new_planet: Planet = planet_prefab.instantiate()
	new_planet.name = name
	new_planet.seed = seed
	new_planet.radius = radius
	new_planet.planet_type = planet_type
	new_planet.terrain_colour = terrain_colour
	new_planet.atmosphere_type = atmosphere_type
	
	return new_planet
	

@tool
extends Node3D
class_name Asteroid
	
@export var asteroid_data:AsteroidData:
	set(val):
		asteroid_data = val
		if asteroid_data != null and not asteroid_data.is_connected("changed", on_data_changed):
			asteroid_data.connect("changed", on_data_changed)


# Called when the node enters the scene tree for the first time.
func _ready():
	on_data_changed()
	


# 	Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#rotate_x(randf_range(0, 0.01))
	#rotate_y(randf_range(0, 0.01))
	#rotate_z(randf_range(0, 0.01))
	pass
	
# method to regenerate the planet from planet data
func on_data_changed():
	# iterate over the child objects
	for child in get_children():
		# particularly concerned with TerrainFaces
		var face := child as TerrainFaceAsteroid
		if face is TerrainFaceAsteroid:
			face.construct_mesh(asteroid_data)
			face.update_textures(asteroid_data)

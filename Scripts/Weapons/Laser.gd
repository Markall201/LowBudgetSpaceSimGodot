extends RayCast3D
class_name Laser

@onready var laser_mesh: MeshInstance3D = $LaserMesh

func _process(delta):
	var cast_point
	force_raycast_update()
	
	# if raycast collides with object, get collision point
	if (is_colliding()):
		cast_point = to_local(get_collision_point())
		# update mesh to go between laser emitter and cast point
		laser_mesh.mesh.height = cast_point.y
		laser_mesh.position.y = cast_point.y/2
	else:
		laser_mesh.mesh.height = 1000.0
		laser_mesh.position.y = -500.0

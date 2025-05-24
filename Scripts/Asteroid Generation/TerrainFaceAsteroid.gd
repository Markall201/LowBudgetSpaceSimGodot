@tool
extends MeshInstance3D
class_name TerrainFaceAsteroid

@export var normal:Vector3
@export var resolution:int= 256

@export var asteroid_data: AsteroidData

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func construct_mesh(planet: AsteroidData):
	
	asteroid_data = planet
	resolution = planet.resolution
	var mesh_data_array := []
	mesh_data_array.resize(Mesh.ARRAY_MAX)
	
	# array of all vertices
	var vertex_array := PackedVector3Array()
	#array of texture coords
	var uv_array := PackedVector2Array()
	# lighting normal map
	var normal_array := PackedVector3Array()
	# array of vertices to store for triangles - think of it as not really including the outer vertices
	var index_array :=PackedInt32Array()
	
	#calc number of vertices
	var num_vertices = resolution * resolution
	# calc number of indices
	var num_indices = (resolution - 1) * (resolution - 1) * 6
	
	# resize arrays
	vertex_array.resize(num_vertices)
	uv_array.resize(num_vertices)
	normal_array.resize(num_vertices)
	index_array.resize(num_indices)
	
	# calc a and b axes: the local "x and y" for the mesh
	# in Sebastian Lague's code this is done in the Constructor but we can do it here 
	var axisA :=Vector3(normal.y, normal.z, normal.x)
	var axisB :Vector3 = normal.cross(axisA)
	
	
	var tri_index:int=0
	# loop to build the mesh
	for y in range(resolution):
		for x in range(resolution):
			
			var i : int = x + y * resolution
			var percentAlongAxes := Vector2(x,y) / (resolution-1)
			# how far along each axis we are, between -1 and 1 (including y)
			var pointOnUnitCube : Vector3 = normal + (percentAlongAxes.x-0.5) * 2.0 * axisA + (percentAlongAxes.y-0.5) * 2.0 * axisB 
			# used to just be pointOnUnitCube.normalized, however this gave seams. To make it better, we apply a nifty equation in the method point_on_cube_to_point_on_sphere()
			var pointOnUnitSphere : Vector3 = point_on_cube_to_point_on_sphere(pointOnUnitCube)
			# apply terrain shaping function to pointOnUnitSphere
			var pointOnPlanet : Vector3 = calculate_vertex_point_on_planet(asteroid_data, pointOnUnitSphere)
			# record pointOnPlanet in array
			vertex_array[i] = pointOnPlanet
			
			# if we're not on the edge of the mesh
			if (x != resolution-1 and y != resolution-1):
				# make the triangles - trust this order to form triangle indexes
				index_array[tri_index+2] = i;
				index_array[tri_index + 1] = i + resolution + 1
				index_array[tri_index] = i + resolution
				index_array[tri_index + 5] = i
				index_array[tri_index + 4] = i + 1
				index_array[tri_index + 3] = i + resolution + 1
				tri_index += 6;
	
	# recalculate normals (manually as Godot doesn't have the same implementation as Unity)
	# iterate over all triangles
	for a in range(0, index_array.size(), 3):
		var b : int = a + 1
		var c : int = a + 2
		# get edges ab, bc, ca in the triangle
		var ab : Vector3 = vertex_array[index_array[b]] - vertex_array[index_array[a]]
		var bc : Vector3 = vertex_array[index_array[c]] - vertex_array[index_array[b]]
		var ca : Vector3 = vertex_array[index_array[a]] - vertex_array[index_array[c]]
		# cross product of ab, bc, ca
		var cross_ab_bc : Vector3 = ab.cross(bc) * -1.0	
		var cross_bc_ca : Vector3 = bc.cross(ca) * -1.0	
		var cross_ca_ab : Vector3 = ca.cross(ab) * -1.0	
		
		# add the 3 together and put in the normal array at the same position as the vertex	
		normal_array[index_array[a]] += cross_ab_bc + cross_bc_ca + cross_ca_ab
		normal_array[index_array[b]] += cross_ab_bc + cross_bc_ca + cross_ca_ab
		normal_array[index_array[c]] += cross_ab_bc + cross_bc_ca + cross_ca_ab
		
	# ensure normals are in the range [0,1] - i.e. normalize them
	for i in range(normal_array.size()):
		normal_array[i] = normal_array[i].normalized()
	
	# finally, put the data in the original mesh array
	mesh_data_array[Mesh.ARRAY_VERTEX] = vertex_array
	mesh_data_array[Mesh.ARRAY_NORMAL] = normal_array
	mesh_data_array[Mesh.ARRAY_TEX_UV] = uv_array
	mesh_data_array[Mesh.ARRAY_INDEX] = index_array
	
	# Godot doesn't always like you modifying mesh buffer things, so use a call_deferred to ensure it's done at a right time
	call_deferred("_update_mesh", mesh_data_array)
	
# this does something I'm sure
func _update_mesh(mesh_data_array : Array):
	var _mesh:= ArrayMesh.new()
	_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, mesh_data_array)
	self.mesh = _mesh
	
	

	
# instead of just normalizing, this improves seams
func point_on_cube_to_point_on_sphere(p:Vector3):
		# square each dimension
		var x2:float = p.x * p.x;
		var y2:float = p.y * p.y;
		var z2:float = p.z * p.z;

		# apply nifty equation
		var xout:float = p.x * sqrt(1 - (y2 + z2) / 2 + (y2 * z2) / 3)
		var yout:float = p.y * sqrt(1 - (z2 + x2) / 2 + (z2 * x2) / 3)
		var zout:float = p.z * sqrt(1 - (x2 + y2) / 2 + (x2 * y2) / 3)

		# return the new x, y and z coords as a Vector3
		return Vector3(xout, yout, zout);
		
	
# once we have a sphere, use this method to create heightmap-based
func calculate_vertex_point_on_planet(planet: AsteroidData, pointOnUnitSphere: Vector3) -> Vector3:
	# get elevation in map [-1,...,1]
	var elevation = planet.height_map.get_noise_3dv(pointOnUnitSphere)
	# remap elevation to [0,...,1]
	elevation = (elevation + 1 / 2.0) * planet.amplitude
	
	# ensure some minimum elevation
	elevation = pointOnUnitSphere * planet.radius * (elevation+1.0)
	
	return elevation
	
	
# current asteroid implementation uses a single colour material so don't worry about this.
# todo: get this to actually show the texture on the planet's surface
func update_textures(planet: AsteroidData):
	
	asteroid_data = planet
	#self.set_material_override(preload("res://Assets/Art/earth_material.tres"))
	#var planetTexture:Texture2D = planet_data.colourmap
	#var mesh_data_array := []
	#mesh_data_array.resize(Mesh.ARRAY_MAX)
#
	#var uv_array := PackedVector2Array()
	#
	#
	##calc number of vertices
	#var num_vertices = resolution * resolution
#
	#uv_array.resize(num_vertices)
#
	#
	## calc a and b axes: the local "x and y" for the mesh
	## in Sebastian Lague's code this is done in the Constructor but we can do it here 
	#var axisA :=Vector3(normal.y, normal.z, normal.x)
	#var axisB :Vector3 = normal.cross(axisA)
	#
	#
	#var tri_index:int=0
	## loop to build the mesh
	#for y in range(resolution):
		#for x in range(resolution):
			#
			#var i : int = x + y * resolution
			#var percentAlongAxes := Vector2(x,y) / (resolution-1)
			## how far along each axis we are, between -1 and 1 (including y)
			#var pointOnUnitCube : Vector3 = normal + (percentAlongAxes.x-0.5) * 2.0 * axisA + (percentAlongAxes.y-0.5) * 2.0 * axisB 
			## used to just be pointOnUnitCube.normalized, however this gave seams. To make it better, we apply a nifty equation in the method point_on_cube_to_point_on_sphere()
			#var pointOnUnitSphere : Vector3 = point_on_cube_to_point_on_sphere(pointOnUnitCube)
			#uv_array[i] = GeoMaths.to_UV(GeoMaths.point_to_coordinate(pointOnUnitSphere))
#
	#mesh_data_array[Mesh.ARRAY_TEX_UV] = uv_array
#
	#
	## Godot doesn't always like you modifying mesh buffer things, so use a call_deferred to ensure it's done at a right time
	#call_deferred("_update_mesh", mesh_data_array)

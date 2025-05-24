extends Node
class_name GeoMaths

const EarthRadiusKM:float = 6371;
const  EarthCircumferenceKM:= EarthRadiusKM * PI * 2;

static func point_to_coordinate(pointOnUnitSphere:Vector3):
	var latitude:float = asin(pointOnUnitSphere.y)
	var a:float = pointOnUnitSphere.x;
	var b:float  = -pointOnUnitSphere.z;

	var longitude:float  = atan2(a, b);
	return Vector2(longitude, latitude);
	

	# Calculate point on sphere given longitude and latitude Vector2 (in radians), and the radius of the sphere
static func coordinate_to_point(coordinate:Vector2, radius:float = 1):
	# Coordinates are represented as Vector2 objects in this implementation
	# x = longitude
	# y = latitude
	var y:float = sin(coordinate.y)
	var r:float = cos(coordinate.y) # radius of 2d circle cut through sphere at 'y'
	var x:float = sin(coordinate.x) * r
	var z:float = -cos(coordinate.x) * r

	return Vector3(x, y, z) * radius

# godot rewritten version
static func DistanceBetweenPointsOnUnitSphere(a:Vector3, b:Vector3):
	
		# Thanks to https://www.movable-type.co.uk/scripts/latlong-vectors.html
		return atan2(a.cross(b).length(), a.dot(b))
		

# a method that takes in long/lat coords and maps them to the range [0, 1]
static func to_UV(coords:Vector2):
	return Vector2((coords.x + PI) / (2 * PI), (coords.y + PI / 2) / PI);

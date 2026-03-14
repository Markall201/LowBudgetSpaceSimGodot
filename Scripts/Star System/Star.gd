@tool
extends Node3D
class_name Star

@export var radius:float = 100.0

# Called when the node enters the scene tree for the first time.
func _ready():
	scale = Vector3(radius, radius, radius)

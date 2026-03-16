extends Node3D

@onready var object:Node3D =  $".."

signal select(system_placeholder)

func _on_area_3d_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		select.emit(self)

extends Node3D

# Ship Weapons System
# When "Fire Weapons" input is triggered,
# if we are able to fire,
# send signal to all weapons

# the parent node (the ship object itself)
@onready var player_ship: RigidBody3D = $".."

var is_active = true


func _input(event):
	if (Input.is_action_pressed("Weapons Fire") && is_active && player_ship.is_controllable):
		print("weapon firing")

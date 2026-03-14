extends Node3D
class_name WeaponsSystem
# Ship Weapons System
# When "Fire Weapons" input is triggered,
# if we are able to fire,
# send signal to all weapons

signal fire_weapons()

# the parent node (the ship object itself)
@onready var player_ship: RigidBody3D = $"../.."

var is_active = true


func _physics_process(delta):
	if (Input.is_action_pressed("Weapons Fire") && is_active && player_ship.is_controllable):
		fire_weapons.emit();


# for now, set all hardpoints to cannons
func _ready():
	var weapon_scene = load("res://Objects/Weapons/projectile_weapon.tscn")
	for child in get_children():
			# particularly concerned with Hardpoints
			var hp := child as Hardpoint
			if hp is Hardpoint:
				print("Hardpoint found!")
				var wp = weapon_scene.instantiate()
				hp.add_weapon(wp)

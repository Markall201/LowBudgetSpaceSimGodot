extends Node3D
class_name Hardpoint
# A hardpoint should have one or no weapons mounted

@export var weapon:Weapon

func add_weapon(newWeapon: Weapon):
	weapon = newWeapon
	add_child(weapon)
	print("weapon mounted")
	

func remove_weapon():
	var removed_weapon: Weapon = weapon
	weapon.queue_free()
	weapon = null
	return removed_weapon

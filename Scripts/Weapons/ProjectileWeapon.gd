extends Weapon
class_name ProjectileWeapon

@onready var projectile = preload("res://Objects/Weapons/Projectile.tscn")

var shot_speed = 300

var firing: bool = false

func _on_fire():
	print("Cannon firing");
	var shot = projectile.instantiate()
	add_child(shot)
	shot.apply_central_impulse(get_global_transform().basis.z * shot_speed);
	
	

	

extends Weapon
class_name BeamLaserWeapon


@onready var laser_scene = preload("res://Objects/Weapons/laser.tscn")
@onready var laser_instance : Laser

func _on_fire():
	laser_instance = laser_scene.instantiate()
	weaponBarrel.add_child(laser_instance)
	firing = true
	
func _physics_process(delta: float):
	pass


func _on_stop_firing():
	firing = false
	laser_instance.queue_free()
	laser_instance = null
	

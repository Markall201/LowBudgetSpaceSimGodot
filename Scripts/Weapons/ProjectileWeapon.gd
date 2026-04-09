extends Weapon
class_name ProjectileWeapon

@export var projectile: PackedScene
@onready var timer:Timer


var can_fire:bool = true

var shot_speed = 300


func _ready():
	super._ready()
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(on_timer_timeout)
	timer.wait_time = 1/refire_rate
	timer.one_shot = false


func _on_fire():
	firing = true

func _physics_process(delta: float):
	if (firing && can_fire):
		can_fire = false
		var shot = projectile.instantiate()
		# set weapon damage
		shot.damage = self.damage
		shot.global_position = weaponBarrel.global_position
		get_tree().get_root().add_child(shot)
		shot.apply_central_impulse(get_global_transform().basis.z * shot_speed);
		timer.start()
		

	
func on_timer_timeout():
	can_fire = true
	
	

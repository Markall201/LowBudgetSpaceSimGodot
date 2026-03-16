extends Node3D
class_name Weapon

# abstract class for weapons
# inherited by BeamLaserWeapon and ProjectileWeapon
# this class handles connecting the signal toWeaponsSystem
# child classes will need to define _on_fire()
@export var damage:float = 1.0
@export var refire_rate:float = 1.0
# WeaponsSystem - currently parent of all hardpoints
@onready var weaponsSystem: WeaponsSystem = $"../.."

# WeaponsSystem - currently parent of all hardpoints
@onready var weaponBarrel: Node3D = $"WeaponModel/WeaponBarrel"

var firing:bool = false

func _ready():
	weaponsSystem.fire_weapons.connect(_on_fire)
	weaponsSystem.stop_firing_weapons.connect(_on_stop_firing)

func _on_fire():
	firing = true
	
func _on_stop_firing():
	firing = false
	

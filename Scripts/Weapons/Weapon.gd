extends Node3D
class_name Weapon

# abstract class for weapons
# inherited by BeamLaserWeapon and ProjectileWeapon
# this class handles connecting the signal toWeaponsSystem
# child classes will need to define _on_fire()
@export var damage:float
@export var refire_rate:float
# WeaponsSystem - currently parent of all hardpoints
@onready var weaponsSystem: WeaponsSystem = $"../.."

# WeaponsSystem - currently parent of all hardpoints
@onready var weaponBarrel: Node3D = $"WeaponModel/WeaponBarrel"

func _ready():
	weaponsSystem.fire_weapons.connect(_on_fire)
	

func _on_fire():
	pass
	

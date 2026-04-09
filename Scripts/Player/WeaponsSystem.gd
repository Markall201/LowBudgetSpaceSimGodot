extends Node3D
class_name WeaponsSystem
# Ship Weapons System
# When "Fire Weapons" input is triggered,
# if we are able to fire,
# send signal to all weapons

signal fire_weapons()

# we also need a signal to stop firing, particularly for laser weapons
signal stop_firing_weapons()

# we need a signal to connect the weapons to this WeaponsSystem
# instead of navigating the scene tree.
# That way we can fire the weapons regardless of where they are in the scene tree
# (even if they're a child of another node) 
signal init_weapons(weaponsSystem)

# the parent node (the ship object itself)
@onready var player_ship: RigidBody3D = $".."
# the ship model (the parent of the hardpoints)
@onready var player_ship_model: Node3D = $"../PlayerShipModel":
	set(val):
		player_ship_model = val
		mount_weapons()
	
	

var is_active:bool = true

var is_firing: bool = false
func _physics_process(delta):
	if (Input.is_action_pressed("Weapons Fire") && is_active && player_ship.is_controllable):
		if (!is_firing):
			fire_weapons.emit()
			is_firing = true
		
	elif (is_firing):
		stop_firing_weapons.emit()
		is_firing = false
		
		
# currently a sample function to set default weapons on all hardpoints
# but might need to do this for individual weapons
func mount_weapons():
	var weapon_scene = load("res://Objects/Weapons/beam_laser_weapon.tscn")
	
	# find the hardpoints on the ship - hardpoints are currently children of the ship model
	for child in player_ship_model.get_children():
			# particularly concerned with Hardpoints
			var hp := child as Hardpoint
			if hp is Hardpoint:
				print("Hardpoint found!")
				var wp = weapon_scene.instantiate()
				hp.add_weapon(wp)
				#object_producing_signal.signal_name.connect(object_with_receiving_method.receiving_method_name)
				self.init_weapons.connect(wp._on_init)
	# connect the weapons to this WeaponsSystem
	init_weapons.emit(self)

# for now, set all hardpoints to lasers
func _ready():
	mount_weapons()

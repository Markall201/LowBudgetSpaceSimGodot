extends CollisionShape3D
class_name ShipModel

# ShipModel needs to be a class so that we can identify it
# when searching children of the PlayerShip
# ShipModel needs to inherit CollisionShape3D so that we can define
# the ship's collider in this object
# we could also store ship information here if needed
# TO DO: more detailed colliders, for now ships just use BoxShape3D

# Ship low level information

@export var forward_thrust: float = 100.0
@export var up_thrust: float = 50.0
@export var strafe_thrust: float = 50.0

@export var yaw_torque: float = 20.0
@export var pitch_torque: float = 20.0
@export var roll_torque: float = 50.0

@export var max_boost_amount: float = 5.0
@export var boost_deprecation_rate: float = 2.0
@export var boost_recharge_rate: float = 0.5

@export var boost_multiplier: float = 5

# ship hull stats

@export var base_hull: int = 250
@export var base_shielding: int = 150

@export var value:int = 12000

extends CollisionShape3D
class_name ShipModel

# ShipModel needs to be a class so that we can identify it
# when searching children of the PlayerShip
# ShipModel needs to inherit CollisionShape3D so that we can define
# the ship's collider in this object
# we could also store ship information here if needed
# TO DO: more detailed colliders, for now ships just use BoxShape3D

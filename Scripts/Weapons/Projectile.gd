extends RigidBody3D

@export var damage:int = 0

@export var despawnTime:float = 5

@onready var timer:float = 0.0

# projectile despawning after despawnTime
func _process(delta: float):
	timer += delta
	if (timer >= despawnTime):
		queue_free()

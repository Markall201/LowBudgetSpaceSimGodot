extends Control
@onready var player_ship = $".."
@onready var progress_bar_throttle = $ProgressBarThrottle
@onready var progress_bar_boost = $ProgressBarBoost
@onready var label_speed = $Container/Label_speed

@export var throttle_value:int  = 0
@export var boost_value:int  = 0
@export var ship_velocity:int  = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# override boost bar max from ship stats (different booster tanks on different ships?)
	progress_bar_boost.max_value = player_ship.max_boost_amount


func updateValues():
	throttle_value = player_ship.current_throttle
	ship_velocity = player_ship.linear_velocity.length()
	
	boost_value = player_ship.current_boost_amount
	
	progress_bar_throttle.value = throttle_value
	progress_bar_boost.value = boost_value
	label_speed.text = str(ship_velocity)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	updateValues()

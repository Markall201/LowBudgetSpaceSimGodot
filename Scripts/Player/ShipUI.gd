extends Control
@onready var player_ship = $".."
@onready var progress_bar_throttle = $ProgressBarThrottle
@onready var progress_bar_boost = $ProgressBarBoost
@onready var label_speed = $Container/Label_speed

@export var throttle_value:float  = 0
@export var boost_value:float  = 0
@export var ship_velocity:int  = 0

var boost_bar_default_colour:Color = Color("f2a82c")
var boost_bar_empty_colour:Color = Color("f24d2c")

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
	
	# set boost bar colour
	if (player_ship.can_boost):
		progress_bar_boost.tint_progress = boost_bar_default_colour
	else:
		progress_bar_boost.tint_progress = boost_bar_empty_colour
		
	label_speed.text = str(ship_velocity)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	updateValues()

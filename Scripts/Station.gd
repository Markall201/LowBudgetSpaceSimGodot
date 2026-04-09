extends Node3D
class_name Station

signal init_landing_pads(station)

@export var station_name:String

func _ready():
	# find the landing pads on the station
	for child in get_children():
			# particularly concerned with Hardpoints
			var pad := child as HangarLandingPad
			if pad is HangarLandingPad:
				print("Pad found!")
				#object_producing_signal.signal_name.connect(object_with_receiving_method.receiving_method_name)
				self.init_landing_pads.connect(pad._on_init)
	# connect the weapons to this WeaponsSystem
	init_landing_pads.emit(self)

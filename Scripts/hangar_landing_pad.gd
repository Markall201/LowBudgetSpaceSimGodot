extends Node3D
class_name HangarLandingPad

# the Area3D used to detect a landing ship
@onready var landing_area_3d: Area3D = $"hangar-pad-visuals/Area3D"
var parent_station:Station = null

func _on_landing_area_3d_body_entered(body: Node3D) -> void:
	# check if the ship is a PlayerShip, if it is then make it available to dock
	var ship := body as PlayerShip
	if ship is PlayerShip:
		if (ship.is_landing_gear_deployed):
			print("Now docked at: " + str(parent_station.station_name))
			ship.dock()

func _on_init(station: Station):
	parent_station = station

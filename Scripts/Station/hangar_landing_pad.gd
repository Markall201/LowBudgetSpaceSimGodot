extends Node3D
class_name HangarLandingPad

# the Area3D used to detect a landing ship
@onready var landing_area_3d: Area3D = $"hangar-pad-visuals/Area3D"
var parent_station:Station = null
@onready var generic_6dof_joint_3d: Generic6DOFJoint3D = $Generic6DOFJoint3D

func _on_landing_area_3d_body_entered(body: Node3D) -> void:
	# check if the ship is a PlayerShip, if it is then make it available to dock
	var ship := body as PlayerShip
	if ship is PlayerShip:
		if (ship.is_landing_gear_deployed):
			ship.dock(self)
			generic_6dof_joint_3d.node_b = ship.get_path()
			parent_station.station_gui.show()
			

func _on_init(station: Station):
	parent_station = station

func ship_undock():
	generic_6dof_joint_3d.node_b = NodePath()
	parent_station.undock()

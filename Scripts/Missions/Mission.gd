extends Node
class_name Mission

enum MissionState {
	Available,
	Active,
	Failed,
	Accomplished,
	Dropped,
	Expired
}

@export var mission_state: MissionState
@export var mission_name: String
@export var mission_description: String
@export var target_system: SystemPlaceholder

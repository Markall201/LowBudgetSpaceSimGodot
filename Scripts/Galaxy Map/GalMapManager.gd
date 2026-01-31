extends Control
@onready var system_label = %"System Label"
@onready var system_stars = %"System Stars"
@onready var system_planets = %"System Planets"
@onready var system_coords = %"System Coords"
@onready var system_seed = %"System Seed"
@onready var system_faction = %"System Faction"


# Called when the node enters the scene tree for the first time.
func _ready():
	setLabelsEmpty()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

signal on_hyperspace_target_system_select(system_placeholder:SystemPlaceholder)

# method to clear the UI text
func setLabelsEmpty():
	system_label.text = ""
	system_stars.text = ""
	system_planets.text = ""
	system_coords.text = ""
	system_seed.text = ""
	system_faction.text = ""
	return

# method to set label data from a system placeholder
func setLabels(system_placeholder:SystemPlaceholder):
	system_label.text = system_placeholder.systemName
	system_stars.text = "NUMBER OF STARS: " + str(system_placeholder.numberOfStars)
	system_planets.text = "NUMBER OF PLANETS: " + str(system_placeholder.numberOfPlanets)
	system_coords.text = "COORDINATES: " + str(system_placeholder.location)
	system_seed.text = "SEED: "  + str(system_placeholder.seed)
	system_faction.text = "FACTION: "  + system_placeholder.faction
	return

# custom signal "highlight" emitted by SystemPlaceholder
func _on_system_placeholder_select(system_placeholder:SystemPlaceholder):
	# pass details to UI
	setLabels(system_placeholder)
	on_hyperspace_target_system_select.emit(system_placeholder)
	

extends Control
class_name StationGUI


@onready var nav_bar_buttons_h_box: HBoxContainer = $Navbar/NavBarButtonsHBox
@onready var button_group: ButtonGroup = preload("res://Objects/UI/station_button_group.tres")
@onready var button_hangar: Button = $"Navbar/NavBarButtonsHBox/Button-Hangar"

# when the navbar's made visible again set the Hangar Button to be pressed by default
func _on_visibility_changed() -> void:
	if (button_hangar != null):
		button_hangar.set_pressed(true)

extends Control
class_name StationGUI


@onready var nav_bar_buttons_h_box: HBoxContainer = $Navbar/NavBarButtonsHBox
@onready var button_group: ButtonGroup = preload("res://Objects/UI/station_button_group.tres")

@onready var button_hangar: Button = $"Navbar/NavBarButtonsHBox/Button-Hangar"

# various station screens are children of the StationMainScreens object
@onready var station_primary_screens: Control = $StationPrimaryScreensContainer


const SHIPYARD = preload("res://Objects/UI/Shipyard.tscn")


func _ready():
	init_button_group()
	button_group.pressed.connect(_on_navbar_button_pressed);
	hide_shipyard();
	
# ensure all the buttons are in the button group resource
func init_button_group():
	for button in nav_bar_buttons_h_box.get_children():
		button.button_group = button_group;

func _on_navbar_button_pressed(button:BaseButton):
	print(button.name);
	ClearMainScreens();
	match (button.name):
		"Button - Hangar":
			hide_shipyard();
		"Button - Shipyard":
			show_shipyard();
		
		
func ClearMainScreens():
	for screen in station_primary_screens.get_children():
		screen.queue_free()
	
func show_shipyard():
	station_primary_screens.add_child(SHIPYARD.instantiate())
	
func hide_shipyard():
	pass
	
# when the navbar's made visible again set the Hangar Button to be pressed by default
func _on_visibility_changed() -> void:
	if (button_hangar != null):
		button_hangar.set_pressed(true)
		
	if (button_group != null):
		print("Buttons: " + str(button_group.get_buttons().size()))

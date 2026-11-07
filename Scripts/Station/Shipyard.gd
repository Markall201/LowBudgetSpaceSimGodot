extends StationPrimaryScreen
class_name Shipyard

@export var ships_for_sale : Array [Resource]
@onready var item_list_ui: ItemList = $ItemList
@onready var tex:Texture2D = preload("res://Assets/UI/starbird-icon-opaque.png")

func _ready():
	for packed_ship in ships_for_sale:
		var ship = packed_ship.instantiate()
		item_list_ui.add_item(ship.ship_model_name, tex)

# when a ship is selected, get its data from the ships_for_sale
func _on_list_item_selected(index: int) -> void:
	var ship = ships_for_sale[index].instantiate();
	print(ship.ship_model_name + " - Cost: " + str(ship.value))

extends Node2D

var item
var quantity

func _on_button1_pressed() -> void:
	quantity = randi_range(1, 4)
	item = randi_range(1, 100)
	if item == 1:
		$"../UserInterface/Inventory".add_item("AzureCrystal", 1)
	elif item >= 2 and item <= 21:
		$"../UserInterface/Inventory".add_item("AzureStone", quantity)
	elif item >= 22 and item <= 51:
		$"../UserInterface/Inventory".add_item("PureWater", quantity)
	else:
		$"../UserInterface/Inventory".add_item("AzureMoss", quantity)

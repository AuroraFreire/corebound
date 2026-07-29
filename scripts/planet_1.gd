extends Node2D

var item
var q

func _on_button1_pressed() -> void:
	q = randi_range(1, 4)
	item = randi_range(1, 100)
	if item >= 0 and item <= 40:
		$"../UserInterface/Inventory".add_item("AzureMoss", q)
	elif item >= 41 and item <= 70:
		$"../UserInterface/Inventory".add_item("PureWater", q)
	elif item >= 71 and item <= 100:
		$"../UserInterface/Inventory".add_item("AzureStone", q)

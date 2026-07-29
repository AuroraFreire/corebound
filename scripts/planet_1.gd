extends Node2D

func _on_button1_pressed() -> void:
	$"../UserInterface/Inventory".add_item(["PureWater", "AzureStone"].pick_random(), randi_range(1, 4))

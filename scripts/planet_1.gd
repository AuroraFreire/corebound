extends Node2D

func _on_button1_pressed() -> void:
	get_node("../Inventory").add_item()

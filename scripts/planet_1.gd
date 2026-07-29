extends Node2D

func _on_button1_pressed() -> void:
	get_node("../Inventory").add_item()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("close_game"):
		get_tree().quit()

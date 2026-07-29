extends Node2D

var inv_toggle = 0

func _ready() -> void:
	if inv_toggle % 2 == 0:
		$"../Inventory".visible = false

func _on_button1_pressed() -> void:
	get_node("../Inventory").add_item()

func _input(event: InputEvent) -> void:
	close_game(event)
	toggle_inventory(event)

func close_game(event: InputEvent) -> void:
	if event.is_action_pressed("close_game"):
		get_tree().quit()

func toggle_inventory(event: InputEvent) -> void:
	if event.is_action_pressed("Open Close Inventory"):
		inv_toggle += 1
		if inv_toggle % 2 != 0:
			$"../Inventory".visible = true
		else:
			$"../Inventory".visible = false

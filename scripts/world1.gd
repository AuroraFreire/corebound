extends Node2D

func _input(event: InputEvent) -> void:
	close_game(event)

func close_game(event: InputEvent) -> void:
	if event.is_action_pressed("close_game"):
		get_tree().quit()

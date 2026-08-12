extends Node

var pointing_finger = preload("res://assets/open_hand_cursor.png")
var closed_hand = preload("res://assets/closed_hand_cursor.png")

func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	Input.set_custom_mouse_cursor(pointing_finger, Input.CURSOR_ARROW)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			Input.set_custom_mouse_cursor(closed_hand, Input.CURSOR_ARROW)
		else:
			Input.set_custom_mouse_cursor(pointing_finger, Input.CURSOR_ARROW)

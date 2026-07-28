extends Node2D

var test: int = 0

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	pass

func _on_button1_pressed() -> void:
	test += 1
	print(test)
	

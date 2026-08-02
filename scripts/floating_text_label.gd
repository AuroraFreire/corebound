class_name FloatingTextLabel
extends Label

var text_veloctity: Vector2 = Vector2.ZERO

func _ready() -> void:
	tween_text()

func _process(delta: float) -> void:
	position -= position.lerp(position - text_veloctity, - 50 * delta)

func tween_text():
	var tween = create_tween()
	var text_movement_horizontal = randi() % 39 - 10
	var text_movement_vertical = randi() % 20 + 40
	text_veloctity = Vector2(text_movement_horizontal, text_movement_vertical)
	tween.tween_property(self, "scale", Vector2.ZERO, 1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

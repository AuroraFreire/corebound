extends TextureRect

func _ready() -> void:
	if randi() % 2 == 0:
		texture = load("res://item_icons/AzureStone.png")
		scale = Vector2(0.35, 0.35)
	else:
		texture = load("res://item_icons/PureWater.png")

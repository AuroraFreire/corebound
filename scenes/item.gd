extends Node2D

var item_name
var item_quantity 

func _ready() -> void:
	if randi() % 2 == 0:
		item_name = "PureWater"
	else:
		item_name = "AzureStone"
	$TextureRect.texture = load("res://item_icons/" + item_name + ".png")
	if item_name == "AzureStone":
		$TextureRect.scale = Vector2(0.35, 0.35)
	var stack_size = int(JsonData.item_data[item_name]["StackSize"])
	item_quantity = randi_range(1, 4)
	if stack_size == 1:
		$Label.visible = false
	else:
		$Label.text = str(item_quantity)

func add_item_quantity(amount_to_add):
	item_quantity += amount_to_add
	$Label.text = str(item_quantity)

func decrease_item_quantity(amount_to_remove):
	item_quantity -= amount_to_remove
	$Label.text = str(item_quantity)

extends Node2D

var item_name
var item_quantity 

func initialize(n, q):
	item_name = n
	item_quantity = q
	$TextureRect.texture = load("res://item_icons/" + item_name + ".png")
	if item_name == "AzureStone":
		$TextureRect.scale = Vector2(0.35, 0.35)
	$Label.visible = int(JsonData.item_data[item_name]["StackSize"]) > 1
	$Label.text = str(item_quantity)
	
func add_item_quantity(amount_to_add):
	item_quantity += amount_to_add
	$Label.text = str(item_quantity)

func decrease_item_quantity(amount_to_remove):
	item_quantity -= amount_to_remove
	$Label.text = str(item_quantity)

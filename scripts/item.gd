extends Node2D

var item_name
var item_quantity 

func initialize(n, q):
	item_name = n
	item_quantity = q
	$TextureRect.texture = load("res://item_icons/" + item_name + ".png")
	$TextureRect.scale = Vector2.ONE * float(JsonData.item_data[item_name].get("IconScale", 1))
	var off = JsonData.item_data[item_name].get("IconOffset", [0, 0])
	$TextureRect.position += Vector2(off[0], off[1])
	$Label.text = str(item_quantity)
	if $TextureRect.material:
		$TextureRect.material = $TextureRect.material.duplicate()
		if item_name == "AzureCrystal" or item_name == "":
			$TextureRect.material.set_shader_parameter("is_active", true)
		else:
			$TextureRect.material.set_shader_parameter("is_active", false)

func add_item_quantity(amount_to_add):
	item_quantity += amount_to_add
	$Label.text = str(item_quantity)

func decrease_item_quantity(amount_to_remove):
	item_quantity -= amount_to_remove
	$Label.text = str(item_quantity)

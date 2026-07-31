extends Node2D

@onready var slots = $"../UserInterface/Hotbar/GridContainer".get_children()
@onready var hotbar = $"../UserInterface/Hotbar"
var item
var quantity
var active_item

func _on_button1_pressed() -> void:
	if hotbar.cooldown_left > 0:
		return
	active_item = slots[PlayerInventory.active_item_slot].item
	if active_item != null and active_item.item_name == "StarterDrill":
		quantity = randi_range(1, 4)
		item = randi_range(1, 100)
		if item == 1:
			$"../UserInterface/Inventory".add_item("AzureCrystal", 1)
		elif item >= 2 and item <= 21:
			$"../UserInterface/Inventory".add_item("AzureStone", quantity)
		elif item >= 22 and item <= 51:
			$"../UserInterface/Inventory".add_item("PureWater", quantity)
		else:
			$"../UserInterface/Inventory".add_item("AzureMoss", quantity)
		hotbar.start_cooldown()
	

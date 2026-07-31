extends Node

func _ready() -> void:
	var world = preload("res://scenes/world1.tscn").instantiate()
	add_child(world)
	await get_tree().process_frame
	await get_tree().process_frame
	var inv = world.get_node("UserInterface/Inventory")
	inv.visible = true
	inv.add_item("AzureMoss", 91)
	inv.add_item("AzureStone", 12)
	var craft = inv.get_node("CraftingGrid")
	craft.get_child(1).add_item("AzureMoss", 2)
	craft.get_child(4).add_item("AzureStone", 1)
	inv.update_crafting_output()
	await get_tree().process_frame
	await get_tree().process_frame
	var img = get_viewport().get_texture().get_image()
	img.save_png("res://tests/layout.png")
	print("viewport size: ", get_viewport().get_visible_rect().size)
	print("window size: ", DisplayServer.window_get_size())
	print("screen size: ", DisplayServer.screen_get_size())
	var bg = inv.get_node("TextureRect")
	print("invbg global rect: ", bg.get_global_rect())
	var grid = inv.get_node("GridContainer")
	print("inv grid global rect: ", grid.get_global_rect())
	get_tree().quit(0)

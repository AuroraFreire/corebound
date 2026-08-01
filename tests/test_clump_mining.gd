extends Node

var failures = 0

func _ready() -> void:
	var world = preload("res://scenes/world1.tscn").instantiate()
	add_child(world)
	await get_tree().process_frame

	var planet = world.get_node("Planet")
	var hotbar = world.get_node("UserInterface/Hotbar")
	var planet_button = planet.get_node("TextureButton")

	var active = hotbar.get_node("GridContainer").get_child(PlayerInventory.active_item_slot).item
	check("drill is the active item", active != null and active.item_name == "StarterDrill")

	planet.spawn_clump("AzureCrystalClump")
	var clump = null
	for child in planet.get_children():
		if child is TextureButton and child != planet_button:
			clump = child
	check("clump button spawned", clump != null)
	if clump == null:
		finish()
		return

	clump.pressed.emit()
	check("mining cooldown started (7.5s)", hotbar.cooldown_left > 7.0)

	await get_tree().create_timer(8.0).timeout

	var found = 0
	for slot in world.get_node("UserInterface/Inventory/GridContainer").get_children():
		if slot.item != null and slot.item.item_name == "AzureCrystal":
			found = slot.item.item_quantity
	check("AzureCrystal awarded after mining", found >= 1)
	check("clump removed after mining", not is_instance_valid(clump))
	finish()

func finish():
	if failures == 0:
		print("ALL TESTS PASSED")
	else:
		print(str(failures) + " TESTS FAILED")
	get_tree().quit(failures)

func check(label, cond):
	if cond:
		print("PASS: " + label)
	else:
		failures += 1
		print("FAIL: " + label)

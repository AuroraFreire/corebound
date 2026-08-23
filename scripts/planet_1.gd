extends Node2D

@onready var floating_text = %FloatingText
@onready var slots = $"../UserInterface/Hotbar/GridContainer".get_children()
@onready var hotbar = $"../UserInterface/Hotbar"
var item
var quantity
var active_item
var multiplier

func _on_button1_pressed() -> void:
	if !BadgesManager.unlocked_badges.has("First Dig"):
		BadgesManager.unlock_badge("First Dig")
	if hotbar.cooldown_left > 0:
		return
	active_item = slots[PlayerInventory.active_item_slot].item
	if active_item != null and active_item.item_name == "Drill":
		multiplier = int(Skills.get_multiplier("resource_boost"))
		if multiplier == 1:
			quantity = randi_range(1, 4)
		else:
			quantity = randi_range(1, 4) + multiplier
		item = randi_range(1, 100)
		if item == 1:
			floating_text.set_text(str(1))
			floating_text.set_icon(preload("res://item_icons/AzureCrystal.png"))
			floating_text.emit_spawn_text.emit()
			$"../UserInterface/Inventory".add_item("AzureCrystal", 1)
		elif item >= 2 and item <= 21:
			floating_text.set_text(str(quantity))
			floating_text.set_icon(preload("res://item_icons/AzureStone.png"))
			floating_text.emit_spawn_text.emit()
			$"../UserInterface/Inventory".add_item("AzureStone", quantity)
		elif item >= 22 and item <= 51:
			floating_text.set_text(str(quantity))
			floating_text.set_icon(preload("res://item_icons/PureWater.png"))
			floating_text.emit_spawn_text.emit()
			$"../UserInterface/Inventory".add_item("PureWater", quantity)
		else:
			floating_text.set_text(str(quantity))
			floating_text.set_icon(preload("res://item_icons/AzureMoss.png"))
			floating_text.emit_spawn_text.emit()
			$"../UserInterface/Inventory".add_item("AzureMoss", quantity)
		try_spawn_clumps()
		hotbar.start_cooldown()

func try_spawn_clumps():
	if randi_range(1, 500) == 1:
		spawn_clump("AzureCrystalClump")
	if randi_range(1, 250) == 1:
		var commons = []
		for item_name in JsonData.item_data:
			if JsonData.item_data[item_name]["ItemCategory"] == "Node" and item_name != "AzureCrystalClump":
				commons.append(item_name)
		spawn_clump(commons.pick_random())

func spawn_clump(clump_name):
	var free_spots = []
	for spot in get_node(clump_name).get_children():
		if not spot.has_meta("clump"):
			free_spots.append(spot)
	if free_spots.size() == 0:
		return
	var spot = free_spots.pick_random()
	var clump = TextureButton.new()
	clump.texture_normal = load("res://assets/" + clump_name + ".png")
	clump.scale = Vector2.ONE * float(JsonData.item_data[clump_name].get("IconScale", 1))
	clump.position = spot.position - clump.texture_normal.get_size() * clump.scale / 2
	clump.pressed.connect(_on_clump_pressed.bind(clump, clump_name, spot))
	add_child(clump)
	spot.set_meta("clump", clump)

func _on_clump_pressed(clump, clump_name, spot):
	if hotbar.cooldown_left > 0:
		return
	active_item = slots[PlayerInventory.active_item_slot].item
	if active_item != null and active_item.item_name == "Drill":
		var mining_time = float(JsonData.item_data[clump_name]["Duration"])
		if hotbar.overdrive_ready == true:
			hotbar.start_cooldown(0.1)
		else:
			hotbar.start_cooldown(mining_time)
		if hotbar.overdrive_ready == true:
			await get_tree().create_timer(0.1).timeout
		else:
			await get_tree().create_timer(mining_time).timeout
		$"../UserInterface/Inventory".add_item(clump_name.trim_suffix("Clump"), randi_range(20, 40))
		clump.queue_free()
		if spot.has_meta("clump"):
			spot.remove_meta("clump")

extends Node2D

const SLOT_CLASS = preload("res://scripts/slot.gd")
const ItemClass = preload("res://scenes/item.tscn")
const HELD_SCALE = Vector2(6.8, 6.8)
const SAVE_LOCATION = "user://SaveFile.json"

@export var singularity_shake_duration = 2.0
@onready var inventory_slots = $GridContainer
@onready var crafting_slots = $CraftingGrid
@onready var output_slot = $OutputSlot
@onready var delete_slot = $Delete
@onready var camera = $"../../Camera2D"
@onready var noise = FastNoiseLite.new()
var holding_item = null
var active_recipe = null
var wallet = Skills.wallet
var stack_size
var badge_slot_count = 0
var noise_i = 0.0
var shake_strength = 0.0
var shake_timer = 0.0
var is_singularity = false

func _ready() -> void:
	stack_size = Skills.get_multiplier("storage")
	if stack_size == 1.0:
		stack_size = 9
	for inv_slot in inventory_slots.get_children():
		inv_slot.gui_input.connect(slot_gui_input.bind(inv_slot))
		inv_slot.slot_type = SLOT_CLASS.SlotType.INVENTORY
	for craft_slot in crafting_slots.get_children():
		craft_slot.gui_input.connect(slot_gui_input.bind(craft_slot))
		craft_slot.slot_type = SLOT_CLASS.SlotType.CRAFTING_INPUT
	output_slot.gui_input.connect(slot_gui_input.bind(output_slot))
	output_slot.slot_type = SLOT_CLASS.SlotType.CRAFTING_OUTPUT
	delete_slot.gui_input.connect(delete_gui_input)
	load_data()
	noise.seed = randi()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.frequency = 0.5

func _process(delta: float) -> void:
	var is_full = true 
	for slot in inventory_slots.get_children():
		if slot.item == null:
			is_full = false
			break
	if is_full and !BadgesManager.unlocked_badges.has("Packed"):
		BadgesManager.unlock_badge("Packed")
	if shake_timer > 0.0:
		shake_timer -= delta
		var time_passed = singularity_shake_duration - shake_timer
		var progress = time_passed / singularity_shake_duration
		shake_strength = progress * 40.0
		camera.offset = get_noise_offset(delta)
		if shake_timer <= 0.0:
			shake_strength = 0.0
			camera.offset = Vector2.ZERO


func slot_gui_input(event: InputEvent, slot: SLOT_CLASS):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			left_click_slot(event, slot)
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			right_click_slot(slot)

func left_click_slot(event, slot):
	if slot.slot_type == SLOT_CLASS.SlotType.CRAFTING_OUTPUT:
		take_from_output()
		return
	if holding_item != null:
		if !slot.item:
			slot.put_into_slot(holding_item)
			holding_item = null
		else:
			if holding_item.item_name != slot.item.item_name:
				var temp_item = slot.item
				slot.pick_from_slot()
				temp_item.global_position = event.global_position
				temp_item.scale = HELD_SCALE
				slot.put_into_slot(holding_item)
				holding_item = temp_item
			else:
				var able_to_add = stack_size - slot.item.item_quantity
				if able_to_add >= holding_item.item_quantity:
					slot.item.add_item_quantity(holding_item.item_quantity)
					holding_item.queue_free()
					holding_item = null
				else:
					slot.item.add_item_quantity(able_to_add)
					holding_item.decrease_item_quantity(able_to_add)
	elif slot.item:
		holding_item = slot.item
		slot.pick_from_slot()
		holding_item.scale = HELD_SCALE
		holding_item.global_position = get_global_mouse_position()
	if slot.slot_type == SLOT_CLASS.SlotType.CRAFTING_INPUT:
		update_crafting_output()

func right_click_slot(slot):
	if slot.slot_type == SLOT_CLASS.SlotType.CRAFTING_OUTPUT:
		return
	if holding_item != null:
		if !slot.item:
			slot.add_item(holding_item.item_name, 1)
			drop_one_from_hand()
		elif slot.item.item_name == holding_item.item_name:
			if slot.item.item_quantity < stack_size:
				slot.item.add_item_quantity(1)
				drop_one_from_hand()
	elif slot.item:
		if slot.item.item_quantity > 1:
			var half = int(ceil(slot.item.item_quantity / 2.0))
			slot.item.decrease_item_quantity(half)
			var new_item = ItemClass.instantiate()
			new_item.initialize(slot.item.item_name, half)
			add_child(new_item)
			holding_item = new_item
		else:
			holding_item = slot.item
			slot.pick_from_slot()
		holding_item.scale = HELD_SCALE
		holding_item.global_position = get_global_mouse_position()
	if slot.slot_type == SLOT_CLASS.SlotType.CRAFTING_INPUT:
		update_crafting_output()

func drop_one_from_hand():
	if holding_item.item_quantity > 1:
		holding_item.decrease_item_quantity(1)
	else:
		holding_item.queue_free()
		holding_item = null

func _input(event):
	if holding_item:
		holding_item.global_position = get_global_mouse_position()

func add_item(item_name, quantity):
	for slot in inventory_slots.get_children():
		if quantity > 0 and slot.item and slot.item.item_name == item_name:
			var n = min(stack_size - slot.item.item_quantity, quantity)
			slot.item.add_item_quantity(n)
			quantity -= n
	for slot in inventory_slots.get_children():
		if quantity > 0 and not slot.item:
			var n = min(stack_size, quantity)
			slot.add_item(item_name, n)
			quantity -= n
	save_data()

func take_from_output():
	is_singularity = false
	if output_slot.item == null:
		return
	if !BadgesManager.unlocked_badges.has("First Craft"):
		BadgesManager.unlock_badge("First Craft")
	if active_recipe["Result"] == "AzureSingularity":
		if !BadgesManager.unlocked_badges.has("Singularity"):
			BadgesManager.unlock_badge("Singularity")
		is_singularity = true
	if holding_item == null:
		holding_item = output_slot.item
		output_slot.pick_from_slot()
		if holding_item.item_name == "AzureSingularity":
			shake()
		holding_item.scale = HELD_SCALE
		holding_item.global_position = get_global_mouse_position()
		consume_crafting_ingredients()
		update_crafting_output()
	elif holding_item.item_name == output_slot.item.item_name:
		if holding_item.item_name == "AzureSingularity":
			shake()
		if holding_item.item_quantity + output_slot.item.item_quantity <= stack_size:
			holding_item.add_item_quantity(output_slot.item.item_quantity)
			consume_crafting_ingredients()
			update_crafting_output()

func consume_crafting_ingredients():
	if active_recipe == null:
		return
	if active_recipe["Type"] == "Shapeless":
		for item_name in active_recipe["Ingredients"]:
			var to_remove = int(active_recipe["Ingredients"][item_name])
			for craft_slot in crafting_slots.get_children():
				if to_remove <= 0:
					break
				if craft_slot.item and craft_slot.item.item_name == item_name:
					var n = min(craft_slot.item.item_quantity, to_remove)
					remove_from_slot(craft_slot, n)
					to_remove -= n
	else:
		for craft_slot in crafting_slots.get_children():
			if craft_slot.item:
				remove_from_slot(craft_slot, 1)

func remove_from_slot(slot, amount):
	if slot.item.item_quantity > amount:
		slot.item.decrease_item_quantity(amount)
	else:
		slot.item.queue_free()
		slot.item = null
		slot.refresh_style()

func update_crafting_output():
	if output_slot.item != null:
		output_slot.item.queue_free()
		output_slot.item = null
		output_slot.refresh_style()
	active_recipe = find_matching_recipe()
	if active_recipe != null:
		output_slot.add_item(active_recipe["Result"], int(active_recipe.get("Count", 1)))
		
func find_matching_recipe():
	var grid = []
	var totals = {}
	for r in 3:
		var row = []
		for c in 3:
			var craft_slot = crafting_slots.get_child(r * 3 + c)
			if craft_slot.item:
				row.append(craft_slot.item.item_name)
				totals[craft_slot.item.item_name] = totals.get(craft_slot.item.item_name, 0) + craft_slot.item.item_quantity
			else:
				row.append(null)
		grid.append(row)
	var trimmed = trim_pattern(grid)
	if trimmed == null:
		return null
	for recipe in JsonData.recipe_data:
		if recipe["Type"] == "Shapeless":
			if shapeless_matches(totals, recipe["Ingredients"]):
				return recipe
		elif shaped_matches(trimmed, recipe["Pattern"]):
			return recipe
	return null

func trim_pattern(rows):
	var min_r = rows.size()
	var max_r = -1
	var min_c = 99
	var max_c = -1
	for r in rows.size():
		for c in rows[r].size():
			if rows[r][c] != null:
				min_r = min(min_r, r)
				max_r = max(max_r, r)
				min_c = min(min_c, c)
				max_c = max(max_c, c)
	if max_r == -1:
		return null
	var out = []
	for r in range(min_r, max_r + 1):
		var out_row = []
		for c in range(min_c, max_c + 1):
			out_row.append(rows[r][c] if c < rows[r].size() else null)
		out.append(out_row)
	return out

func shaped_matches(trimmed, pattern):
	var cleaned = []
	for row in pattern:
		var out_row = []
		for cell in row:
			out_row.append(null if cell == "" else cell)
		cleaned.append(out_row)
	cleaned = trim_pattern(cleaned)
	if cleaned == null:
		return false
	if trimmed == cleaned:
		return true
	var mirrored = []
	for row in cleaned:
		var flipped = row.duplicate()
		flipped.reverse()
		mirrored.append(flipped)
	return trimmed == mirrored
	
func shapeless_matches(totals, ingredients):
	if totals.size() != ingredients.size():
		return false
	for item_name in ingredients:
		if totals.get(item_name, 0) < int(ingredients[item_name]):
			return false
	return true

func delete_gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if holding_item != null:
			holding_item.queue_free()
			holding_item = null
	save_data()

func save_data():
	var slots_data = []
	for slot in inventory_slots.get_children():
		if slot.item:
			slots_data.append({
				"item_name": slot.item.item_name,
				"quantity": slot.item.item_quantity
			})
		else:
			slots_data.append(null)
	var file = FileAccess.open(SAVE_LOCATION, FileAccess.WRITE)
	file.store_string(JSON.stringify({"wallet": wallet, "slots": slots_data}))
	file.close()

func load_data():
	if !FileAccess.file_exists(SAVE_LOCATION):
		return
	var file = FileAccess.open(SAVE_LOCATION, FileAccess.READ)
	var text = file.get_as_text()
	file.close()
	var data = JSON.parse_string(text)
	if data == null or not data is Dictionary:
		return
	Skills.wallet = int(data.get("wallet", 0))
	$Wallet.text = str(Skills.wallet)
	var slots = inventory_slots.get_children()
	var slots_data = data.get("slots", [])
	for i in range(min(slots.size(), slots_data.size())):
		var slot = slots[i]
		if slot.item:
			slot.item.queue_free()
			slot.item = null
		if slots_data[i] != null:
			slot.add_item(
				slots_data[i]["item_name"],
				int(slots_data[i]["quantity"])
			)

func shake() -> void:
	shake_strength = 40.0
	shake_timer = singularity_shake_duration
	$"..".inv_toggle += 1
	flash()
	var planet_texture = $"../../Planet".get_node("TextureButton")
	await get_tree().create_timer(5.1).timeout
	planet_texture.texture_normal = preload("res://assets/Planet1Core.png")
	planet_texture.texture_hover = preload("res://assets/Planet1Core.png")
	planet_texture.texture_pressed = preload("res://assets/Planet1Core.png")
	planet_texture.material.set_shader_parameter("is_active", true)
	if !BadgesManager.unlocked_badges.has("Corebound"):
		BadgesManager.unlock_badge("Corebound")
	await get_tree().create_timer(3).timeout
	get_tree().change_scene_to_file("res://scenes/cutscene.tscn")

func get_noise_offset(delta: float) -> Vector2:
	noise_i += delta * 30.0
	return Vector2(
		noise.get_noise_2d(1.0, noise_i) * shake_strength,
		noise.get_noise_2d(100.0, noise_i) * shake_strength
	)

func flash():
	await get_tree().create_timer(5.0).timeout
	$"../../FlashAnimation".play("flash")

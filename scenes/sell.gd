extends Node2D

const SLOT_CLASS = preload("res://scripts/slot.gd")
const ItemClass = preload("res://scenes/item.tscn")
const HELD_SCALE = Vector2(6.8, 6.8)
const SAVE_LOCATION = "user://SaveFile.json"

@onready var inventory_slots = $GridContainer
@onready var sell_slot = $SellSlot
var holding_item = null
var price
var quantity
var total
var wallet = 0

func _ready() -> void:
	for inv_slot in inventory_slots.get_children():
		inv_slot.gui_input.connect(slot_gui_input.bind(inv_slot))
		inv_slot.slot_type = SLOT_CLASS.SlotType.INVENTORY
	sell_slot.gui_input.connect(slot_gui_input.bind(sell_slot))
	sell_slot.slot_type = SLOT_CLASS.SlotType.INVENTORY
	$Wallet.text = str(wallet)
	sell()
	load_data()

func slot_gui_input(event: InputEvent, slot: SLOT_CLASS):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			left_click_slot(event, slot)
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			right_click_slot(slot)
		sell()
	if event.is_action_pressed("close_game"):
		get_tree().change_scene_to_file("res://scenes/lab.tscn")

func left_click_slot(event, slot):
	if holding_item != null:
		if !slot.item:
			slot.put_into_slot(holding_item)
			holding_item = null
			if sell_slot.item != null:
				sell()
		else:
			if holding_item.item_name != slot.item.item_name:
				var temp_item = slot.item
				slot.pick_from_slot()
				temp_item.global_position = event.global_position
				temp_item.scale = HELD_SCALE
				slot.put_into_slot(holding_item)
				holding_item = temp_item
				if sell_slot.item != null:
					sell()
			else:
				var stack_size = int(JsonData.item_data[slot.item.item_name]["StackSize"])
				var able_to_add = stack_size - slot.item.item_quantity
				if able_to_add >= holding_item.item_quantity:
					slot.item.add_item_quantity(holding_item.item_quantity)
					holding_item.queue_free()
					holding_item = null
					sell()
				else:
					slot.item.add_item_quantity(able_to_add)
					holding_item.decrease_item_quantity(able_to_add)
	elif slot.item:
		holding_item = slot.item
		slot.pick_from_slot()
		holding_item.scale = HELD_SCALE
		holding_item.global_position = get_global_mouse_position()
		sell()

func right_click_slot(slot):
	if holding_item != null:
		if !slot.item:
			slot.add_item(holding_item.item_name, 1)
			drop_one_from_hand()
		elif slot.item.item_name == holding_item.item_name:
			var stack_size = int(JsonData.item_data[slot.item.item_name]["StackSize"])
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

func drop_one_from_hand():
	if holding_item.item_quantity > 1:
		holding_item.decrease_item_quantity(1)
	else:
		holding_item.queue_free()
		holding_item = null

func _input(event: InputEvent):
	if event.is_action_pressed("close_game"):
		get_tree().change_scene_to_file("res://scenes/lab.tscn")
	if holding_item:
		holding_item.global_position = get_global_mouse_position()
		
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
	wallet = int(data.get("wallet", 0))
	$Wallet.text = str(wallet)
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

func sell():
	if sell_slot.item != null:
		price = int(JsonData.item_data[sell_slot.item.item_name]["Price"])
		quantity = int(sell_slot.item.item_quantity)
		total = price * quantity
		$Price.text = str(total)
		$Sell.set("theme_override_colors/font_color", Color(1.0, 1.0, 0.0, 1.0))
		$Sell.set("theme_override_colors/font_hover_color", Color(1.0, 0.875, 0.0, 1.0))
		$Sell.set("theme_override_colors/font_pressed_color", Color(1.0, 0.71, 0.0, 1.0))
	else:
		$Price.text = "0"
		$Sell.set("theme_override_colors/font_color", "424242")
		$Sell.set("theme_override_colors/font_hover_color", "424242")
		$Sell.set("theme_override_colors/font_pressed_color", "424242")
		
func _on_button_pressed() -> void:
	if sell_slot.item != null:
		sell_slot.item.queue_free()
		sell_slot.item = null
		add_coin()
		sell()
		save_data()
	else:
		return

func add_coin():
	wallet += total
	$Wallet.text = str(wallet)

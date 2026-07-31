extends Node2D

const SLOT_CLASS = preload("res://scripts/slot.gd")
@onready var inventory_slots = $GridContainer
var holding_item = null

func _ready() -> void:
	for inv_slot in inventory_slots.get_children():
		inv_slot.gui_input.connect(slot_gui_input.bind(inv_slot))
		inv_slot.slot_type = SLOT_CLASS.SlotType.INVENTORY

func slot_gui_input(event: InputEvent, slot: SLOT_CLASS):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			if holding_item != null:
				if !slot.item:
					slot.put_into_slot(holding_item)
					holding_item = null
				else:
					if holding_item.item_name != slot.item.item_name:
						var temp_item = slot.item
						slot.pick_from_slot()
						temp_item.global_position = event.global_position
						slot.put_into_slot(holding_item)
						holding_item = temp_item
					else:
						var stack_size = int(JsonData.item_data[slot.item.item_name]["StackSize"])
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
				holding_item.global_position = get_global_mouse_position()

func _input(event):
	if holding_item:
		holding_item.global_position = get_global_mouse_position()

func add_item(item_name, quantity):
	var stack = int(JsonData.item_data[item_name]["StackSize"])
	for slot in inventory_slots.get_children():
		if quantity > 0 and slot.item and slot.item.item_name == item_name:
			var n = min(stack - slot.item.item_quantity, quantity)
			slot.item.add_item_quantity(n)
			quantity -= n
	for slot in inventory_slots.get_children():
		if quantity > 0 and not slot.item:
			var n = min(stack, quantity)
			slot.add_item(item_name, n)
			quantity -= n

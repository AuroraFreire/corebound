extends Node2D

const SLOT_CLASS = preload("res://scripts/slot.gd")
const STARTNG_ITEMS = ["StarterDrill", "Medkit"]

func _ready() -> void:
	for i in STARTNG_ITEMS.size():
		$GridContainer.get_child(i).add_item(STARTNG_ITEMS[i], 1)
	for slot in $GridContainer.get_children():
		slot.slot_index = slot.get_index()
		slot.slot_type = SLOT_CLASS.SlotType.HOTBAR
		PlayerInventory.active_item_updated.connect(slot.refresh_style)
		slot.refresh_style()

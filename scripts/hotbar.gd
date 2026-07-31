extends Node2D

@onready var slots = $GridContainer.get_children()

const SLOT_CLASS = preload("res://scripts/slot.gd")
const STARTNG_ITEMS = ["StarterDrill", "Medkit"]

func _ready() -> void:
	update_active_item_label()
	PlayerInventory.active_item_updated.connect(self.update_active_item_label)
	for i in STARTNG_ITEMS.size():
		$GridContainer.get_child(i).add_item(STARTNG_ITEMS[i], 1)
	for slot in slots:
		slot.slot_index = slot.get_index()
		slot.slot_type = SLOT_CLASS.SlotType.HOTBAR
		PlayerInventory.active_item_updated.connect(slot.refresh_style)
		slot.refresh_style()

func update_active_item_label():
	if slots[PlayerInventory.active_item_slot].item != null:
		if slots[PlayerInventory.active_item_slot].item.item_name == "StarterDrill":
			$ActiveItemLabel.text = "Starter Drill"
		elif slots[PlayerInventory.active_item_slot].item.item_name == "Medkit":
			$ActiveItemLabel.text = "Medkit"
		else:
			$ActiveItemLabel.text = "nothing to see here"

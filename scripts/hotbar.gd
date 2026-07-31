extends Node2D

@onready var slots = $GridContainer.get_children()

const SLOT_CLASS = preload("res://scripts/slot.gd")
const STARTNG_ITEMS = ["StarterDrill", "Medkit"]

var count = 0
var active_item
var cooldown_left = 0.0

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

func _process(delta):
	if cooldown_left > 0:
		cooldown_left -= delta
		$Cooldown.value = max(cooldown_left, 0)
	if $Cooldown.value == 0:
		$Cooldown.visible = false

func update_active_item_label():
	if slots[PlayerInventory.active_item_slot].item != null:
		if slots[PlayerInventory.active_item_slot].item.item_name == "StarterDrill":
			$ActiveItemLabel.text = "Starter Drill"
		elif slots[PlayerInventory.active_item_slot].item.item_name == "Medkit":
			$ActiveItemLabel.text = "Medkit"
	elif count == 0:
		$ActiveItemLabel.text = "Starter Drill"
		count += 1
	else:
		$ActiveItemLabel.text = ""

func start_cooldown():
	$Cooldown.visible = true
	var active_item = slots[PlayerInventory.active_item_slot].item
	if active_item == null:
		return
	cooldown_left = float(JsonData.item_data[active_item.item_name].get("Cooldown", 0))
	$Cooldown.max_value = cooldown_left
	$Cooldown.value = cooldown_left

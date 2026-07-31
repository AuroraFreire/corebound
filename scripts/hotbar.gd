extends Node2D

@onready var slots = $GridContainer.get_children()

const SLOT_CLASS = preload("res://scripts/slot.gd")
const STARTNG_ITEMS = ["StarterDrill", "Medkit", "OxygenTank", "Overdrive"]

var count = 0
var active_item
var cooldown_left = 0.0
var cooldown_overdrive = 0.0
var overdrive_ready = false

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
		$CooldownDrill.value = max(cooldown_left, 0)
	if cooldown_left <= 0:
		$CooldownDrill.visible = false
		$CooldownMedkit.visible = false
		$CooldownOxygen.visible = false
	if cooldown_overdrive > 0:
		cooldown_overdrive -= delta
		$CooldownOverdrive.value = max(cooldown_overdrive, 0)
	if cooldown_overdrive <= 0:
		$CooldownOverdrive.visible = false
	if overdrive_ready:
		$OverdriveCountdown.visible = true
		$OverdriveCountdown.text = str(int(ceil($Timer.time_left)))
	else:
		$OverdriveCountdown.visible = false

func update_active_item_label():
	if slots[PlayerInventory.active_item_slot].item != null:
		if slots[PlayerInventory.active_item_slot].item.item_name == "StarterDrill":
			$ActiveItemLabel.text = "Starter Drill"
		elif slots[PlayerInventory.active_item_slot].item.item_name == "Medkit":
			$ActiveItemLabel.text = "Medkit"
		elif slots[PlayerInventory.active_item_slot].item.item_name == "OxygenTank":
			$ActiveItemLabel.text = "Oxygen Tank"
		elif slots[PlayerInventory.active_item_slot].item.item_name == "Overdrive":
			$ActiveItemLabel.text = "Overdrive"
	elif count == 0:
		$ActiveItemLabel.text = "Starter Drill"
		count += 1
	else:
		$ActiveItemLabel.text = ""

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("overdrive"):
		var active_item = slots[PlayerInventory.active_item_slot].item
		if active_item != null and active_item.item_name == "Overdrive" and cooldown_overdrive <= 0:
			start_cooldown()
			overdrive_ready = true
			$Timer.start()

func _on_timer_timeout() -> void:
	overdrive_ready = false

func start_cooldown():
	var active_item = slots[PlayerInventory.active_item_slot].item
	if active_item == null:
		return
	var cd = 0.0
	if overdrive_ready:
		cd = 0.1
	else:
		cd = float(JsonData.item_data[active_item.item_name].get("Cooldown", 0))
	if slots[PlayerInventory.active_item_slot].item.item_name == "StarterDrill":
		cooldown_left = cd
		$CooldownDrill.visible = true
		$CooldownDrill.max_value = cd
		$CooldownDrill.value = cd
	elif slots[PlayerInventory.active_item_slot].item.item_name == "Overdrive":
		cooldown_overdrive = cd
		$CooldownOverdrive.visible = true
		$CooldownOverdrive.max_value = cd
		$CooldownOverdrive.value = cd

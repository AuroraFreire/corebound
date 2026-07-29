extends CanvasLayer

var inv_toggle = 0

func _ready() -> void:
	if inv_toggle % 2 == 0:
		$Inventory.visible = false

func _input(event: InputEvent) -> void:
	toggle_inventory(event)

func toggle_inventory(event: InputEvent) -> void:
	if event.is_action_pressed("Open Close Inventory"):
		inv_toggle += 1
		if inv_toggle % 2 != 0:
			$Inventory.visible = true
		else:
			$Inventory.visible = false

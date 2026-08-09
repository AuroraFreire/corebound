extends CanvasLayer

var inv_toggle = 0


func _ready() -> void:
	if inv_toggle % 2 == 0:
		$Inventory.visible = false
	$".".process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event: InputEvent) -> void:
	toggle_inventory(event)
	close_game(event)

func close_game(event: InputEvent) -> void:
	if event.is_action_pressed("close_game"):
		get_tree().quit()

func toggle_inventory(event: InputEvent) -> void:
	await get_tree().create_timer(0.1).timeout
	if event.is_action_pressed("Open Close Inventory"):
		inv_toggle += 1
		if inv_toggle % 2 != 0:
			$Inventory.visible = true
			$Inventory/Wallet.text = str(Skills.wallet)
			get_tree().paused = true
		else:
			$Inventory.visible = false
			$Inventory/Wallet.text = str(Skills.wallet)
			get_tree().paused = false

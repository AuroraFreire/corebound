extends CanvasLayer

var inv_toggle = 0

func _ready() -> void:
	if inv_toggle % 2 == 0:
		$Inventory.visible = false
	$".".process_mode = Node.PROCESS_MODE_ALWAYS
	$"../HomeBannerAnim".process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event: InputEvent) -> void:
	toggle_inventory(event)
	scroll_hotbar(event)
	close_game(event)

func _process(delta: float) -> void:
	if inv_toggle % 2 != 0:
			$Inventory.visible = true
			$Inventory/Wallet.text = str(Skills.wallet)
			get_tree().paused = true
	else:
		$Inventory.visible = false
		$Inventory/Wallet.text = str(Skills.wallet)
		get_tree().paused = false

func close_game(event: InputEvent) -> void:
	if event.is_action_pressed("close_game"):
		get_tree().quit()

func toggle_inventory(event: InputEvent) -> void:
	if event.is_action_pressed("Open Close Inventory"):
		inv_toggle += 1


func scroll_hotbar(event: InputEvent) -> void:
	if event.is_action_pressed("scroll_up"):
		PlayerInventory.active_item_scroll_up()
	elif event.is_action_pressed("scroll_down"):
		PlayerInventory.active_item_scroll_down()

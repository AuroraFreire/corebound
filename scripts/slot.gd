extends Panel

var ItemClass = preload("res://scenes/item.tscn")
var item = null
var filled_slot = preload("res://assets/SlotBG.png")
var empty_slot = preload("res://assets/EmptySlotBG.png")
var selected_slot = preload("res://assets/SlotHotbarBG.png")
var delete_opened_slot = preload("res://assets/DeleteOpened.png")
var delete_closed_slot = preload("res://assets/DeletedClosed.png")
var filled_style: StyleBoxTexture = null
var empty_style: StyleBoxTexture = null
var selected_style: StyleBoxTexture = null
var delete_opened_style: StyleBoxTexture = null
var delete_closed_style: StyleBoxTexture = null
var slot_index
var slot_type

enum SlotType {
	HOTBAR = 0,
	INVENTORY,
	CRAFTING_INPUT,
	CRAFTING_OUTPUT,
}

func _ready() -> void:
	filled_style = StyleBoxTexture.new()
	empty_style = StyleBoxTexture.new()
	selected_style = StyleBoxTexture.new()
	delete_opened_style = StyleBoxTexture.new()
	delete_closed_style = StyleBoxTexture.new()
	filled_style.texture = filled_slot
	empty_style.texture = empty_slot
	selected_style.texture = selected_slot
	delete_opened_style.texture = delete_opened_slot
	delete_closed_style.texture = delete_closed_slot
	refresh_style()

func refresh_style():
	if SlotType.HOTBAR == slot_type and PlayerInventory.active_item_slot == slot_index:
		add_theme_stylebox_override("panel", selected_style)
	elif item != null:
		add_theme_stylebox_override("panel", filled_style)
	elif self.name == "Delete":
		add_theme_stylebox_override("panel", delete_closed_style)
	else:
		add_theme_stylebox_override("panel", empty_style)

func add_item(item_name, item_quantity) -> void:
	item = ItemClass.instantiate()
	item.initialize(item_name, item_quantity)
	add_child(item)
	refresh_style()

func pick_from_slot():
	remove_child(item)
	var inventory_node = find_parent("Inventory")
	inventory_node.add_child(item)
	item.scale = get_parent().scale
	item = null
	refresh_style()

func put_into_slot(new_item):
	item = new_item
	item.scale = Vector2.ONE
	item.position = Vector2.ZERO
	var inventory_node = find_parent("Inventory")
	inventory_node.remove_child(item)
	add_child(item)
	refresh_style()

func _on_mouse_entered() -> void:
	if self.name == "Delete":
		add_theme_stylebox_override("panel", delete_opened_style)
		self.scale = Vector2(1.05, 1.05)

func _on_mouse_exited() -> void:
	if self.name == "Delete":
		add_theme_stylebox_override("panel", delete_closed_style)
		self.scale = Vector2(1, 1)

func _on_popup_mouse_entered() -> void:
	if item != null:
		Popups.item_poup(Rect2i(Vector2i(global_position), Vector2i(size)), item)

func _on_popup_mouse_exited() -> void:
	Popups.hide_item_popup()

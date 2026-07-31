extends Panel

var ItemClass = preload("res://scenes/item.tscn")
var item = null
var filled_slot = preload("res://assets/SlotBG.png")
var empty_slot = preload("res://assets/EmptySlotBG.png")
var selected_slot = preload("res://assets/SlotHotbarBG.png")
var filled_style: StyleBoxTexture = null
var empty_style: StyleBoxTexture = null
var selected_style: StyleBoxTexture = null
var slot_index
var slot_type

enum SlotType {
	HOTBAR = 0,
	INVENTORY,
}

func _ready() -> void:
	filled_style = StyleBoxTexture.new()
	empty_style = StyleBoxTexture.new()
	selected_style = StyleBoxTexture.new()
	filled_style.texture = filled_slot
	empty_style.texture = empty_slot
	selected_style.texture = selected_slot
	refresh_style()

func refresh_style():
	if SlotType.HOTBAR == slot_type and PlayerInventory.active_item_slot == slot_index:
		add_theme_stylebox_override("panel", selected_style)
	elif item != null:
		add_theme_stylebox_override("panel", filled_style)
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

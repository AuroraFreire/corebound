extends Panel

var ItemClass = preload("res://item.tscn")
var item = null
var filled_slot = preload("res://SlotBG.png")
var empty_slot = preload("res://EmptySlotBG.png")
var filled_style: StyleBoxTexture = null
var empty_style: StyleBoxTexture = null

func _ready() -> void:
	filled_style = StyleBoxTexture.new()
	empty_style = StyleBoxTexture.new()
	filled_style.texture = filled_slot
	empty_style.texture = empty_slot

func refresh_style():
	if item != null:
		add_theme_stylebox_override("panel", filled_style)
	else:
		add_theme_stylebox_override("panel", empty_style)

func add_item() -> void:
	item = ItemClass.instantiate()
	add_child(item)
	refresh_style()

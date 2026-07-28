extends Panel

var ItemClass = preload("res://item.tscn")
var item = null

func add_item() -> void:
	item = ItemClass.instantiate()
	add_child(item)

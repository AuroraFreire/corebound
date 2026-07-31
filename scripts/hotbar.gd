extends Node2D

const STARTNG_ITEMS = ["StarterDrill", "Medkit"]

func _ready() -> void:
	for i in STARTNG_ITEMS.size():
		$GridContainer.get_child(i).add_item(STARTNG_ITEMS[i], 1)

extends Node2D

func add_item() -> bool:
	for slot in $GridContainer.get_children():
		if slot.item == null:
			slot.add_item()
			return true
	return false

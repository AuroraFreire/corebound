extends Node

var failures = 0

func _ready() -> void:
	var inv = preload("res://scenes/inventory.tscn").instantiate()
	add_child(inv)
	var trash = inv.get_node("Delete")
	var opened = preload("res://assets/DeleteOpened.png")
	var closed = preload("res://assets/DeletedClosed.png")

	check("trash starts closed", panel_texture(trash) == closed)
	check("mouse_entered is connected", trash.mouse_entered.get_connections().size() > 0)
	check("mouse_exited is connected", trash.mouse_exited.get_connections().size() > 0)

	trash.mouse_entered.emit()
	check("lid opens on hover", panel_texture(trash) == opened)

	trash.mouse_exited.emit()
	check("lid closes when mouse leaves", panel_texture(trash) == closed)

	check("trash detects mouse (filter not IGNORE)", trash.mouse_filter != Control.MOUSE_FILTER_IGNORE)

	if failures == 0:
		print("ALL TESTS PASSED")
	else:
		print(str(failures) + " TESTS FAILED")
	get_tree().quit(failures)

func panel_texture(slot):
	var style = slot.get_theme_stylebox("panel")
	return style.texture if style is StyleBoxTexture else null

func check(label, cond):
	if cond:
		print("PASS: " + label)
	else:
		failures += 1
		print("FAIL: " + label)

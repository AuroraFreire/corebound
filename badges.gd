extends Node2D

@onready var badges = $Panel/ScrollContainer/GridContainer

func _ready() -> void:
	for badge_node in badges.get_children():
		badge_node.self_modulate = Color(0.277, 0.277, 0.277, 1.0)
	BadgesManager.badge_updated.connect(update_colors)
	update_colors()

func update_colors():
	var list = BadgesManager.unlocked_badges
	if typeof(list) != TYPE_ARRAY:
		list = []
	for badge_node in badges.get_children():
		if list.has(badge_node.name):
				badge_node.self_modulate = Color(1.0, 1.0, 1.0, 1.0)

func _on_button_pressed() -> void:
	$".".visible = false
	$"..".process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = false

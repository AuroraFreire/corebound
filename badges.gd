extends Node2D

@onready var badges = $Panel/ScrollContainer/GridContainer

func _ready() -> void:
	for badge_node in badges.get_children():
		if badge_node.name.contains("Panel"):
			badge_node.self_modulate = Color(0.277, 0.277, 0.277, 1.0)
	BadgesManager.badge_updated.connect(update_colors)
	update_colors()

func update_colors():
	var lista = BadgesManager.unlocked_badges
	if typeof(lista) != TYPE_ARRAY:
		lista = []
	for badge_node in badges.get_children():
		if badge_node.name.contains("Panel"):
			if lista.has(badge_node.name):
				badge_node.self_modulate = Color(1.0, 1.0, 1.0, 1.0)

func _on_button_pressed() -> void:
	$".".visible = false
	get_tree().paused = false

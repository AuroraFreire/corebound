extends Node

signal badge_updated

@onready var badge_popup = preload("res://badge_popup.tscn")
var unlocked_badges = []

func _ready() -> void:
	load_badges()

func unlock_badge(badge_name):
	if not unlocked_badges.has(badge_name):
		unlocked_badges.append(badge_name)
		badge_updated.emit()
		badge_anim(badge_name)
		save_badges()

func badge_anim(badge_name):
	var instance = badge_popup.instantiate()
	var current_scene = get_tree().current_scene
	instance.process_mode = Node.PROCESS_MODE_ALWAYS
	instance.z_index = 4096
	if current_scene.name == "SkillTree":
		var canvas_layer = current_scene.get_node("CanvasLayer")
		if canvas_layer:
			canvas_layer.add_child(instance)
			return
	current_scene.add_child(instance)
	var label = instance.get_node("TextureRect/BadgeName")
	label.text = badge_name

func save_badges():
	var file = FileAccess.open("user://SaveBadges.json", FileAccess.WRITE)
	if file:
		var json_string = JSON.stringify(unlocked_badges, "\t")
		file.store_string(json_string)
		file.close()

func load_badges():
	if not FileAccess.file_exists("user://SaveBadges.json"):
		return
	var file = FileAccess.open("user://SaveBadges.json", FileAccess.READ)
	var text = file.get_as_text()
	file.close()
	unlocked_badges = JSON.parse_string(text)
	badge_updated.emit()

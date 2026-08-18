extends Node

signal badge_updated

var unlocked_badges = []

func _ready() -> void:
	load_badges()

func unlock_badge(badge_name):
	if not unlocked_badges.has(badge_name):
		unlocked_badges.append(badge_name)
		print("works")
		badge_updated.emit()
		save_badges()

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

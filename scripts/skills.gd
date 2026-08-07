extends Node

var wallet = 0
var skill_data = {}
var unlocked = []

func _ready() -> void:
	var file = FileAccess.open("res://Data/SkillData.json", FileAccess.READ)
	skill_data = JSON.parse_string(file.get_as_text())
	file.close()

func is_bought(id):
	return id in unlocked

func is_available(id):
	if is_bought(id):
		return false
	for req in skill_data[id]["Requires"]:
		if !is_bought(req):
			return false
	return true

func buy(id):
	var cost = int(skill_data[id]["Cost"])
	if !is_available(id) or wallet < cost:
		return false
	wallet -= cost
	unlocked.append(id)
	return true

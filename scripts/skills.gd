extends Node

const SAVE_LOCATION = "user://SaveFile.json"
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
	for req in skill_data[id]["Requirements"]:
		if req == null:
			return true
		elif !is_bought(req):
			return false
	return true

func buy(id):
	var cost = int(skill_data[id]["Cost"])
	print("id=", id, " cost=", cost, " wallet=", wallet, " available=", is_available(id), " unlocked=", unlocked)
	if !is_available(id) or wallet < cost:
		return false
	wallet -= cost
	unlocked.append(id)
	return true

func load_wallet():
	if !FileAccess.file_exists(SAVE_LOCATION):
		return
	var file = FileAccess.open(SAVE_LOCATION, FileAccess.READ)
	var text = file.get_as_text()
	file.close()
	var data = JSON.parse_string(text)
	if data == null or not data is Dictionary:
		return
	wallet = int(data.get("wallet", 0))

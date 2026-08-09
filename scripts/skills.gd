extends Node

const SAVE_LOCATION = "user://SaveFile.json"
var wallet = 0
var skill_data = {}
var unlocked = []
var scene
var button

func _ready() -> void:
	var file = FileAccess.open("res://Data/SkillData.json", FileAccess.READ)
	skill_data = JSON.parse_string(file.get_as_text())
	file.close()

func test():
	for skill in skill_data:
		if is_available(skill):
			scene = get_tree().current_scene
			var found_button = find_node_by_name(scene, str(skill))
			if found_button != null:
				button = found_button as TextureButton
				button.modulate = Color(0.735, 0.735, 0.735, 1.0)
	if scene:
		update_colors_recursive(scene)

func find_node_by_name(current_node, target_name):
	if current_node.name == target_name:
		return current_node
	for child in current_node.get_children():
		var result = find_node_by_name(child, target_name)
		if result != null:
			return result
	return null

func update_colors_recursive(current_node):
	if current_node is TextureButton and String(current_node.name) in skill_data:
		var skill_id = String(current_node.name)
		if is_bought(skill_id):
			current_node.modulate = Color(1.0, 1.0, 1.0)
		elif is_available(skill_id):
			current_node.modulate = Color(0.72, 0.72, 0.72)
		else:
			current_node.modulate = Color(0.39, 0.39, 0.39)
	for child in current_node.get_children():
		update_colors_recursive(child)

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
	if !is_available(id) or wallet < cost:
		return false
	wallet -= cost
	unlocked.append(id)
	buy_color(id)
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

func buy_color(id):
	scene = get_tree().current_scene
	var found_button = find_node_by_name(scene, str(id))
	if found_button != null:
		button = found_button as TextureButton
		button.modulate = Color(1.0, 1.0, 1.0)
	test()

extends Node

const SAVE_LOCATION = "user://SaveFile.json"
const SAVE_LOCATION_SKILLS = "user://SkillSaveFile.json"
var wallet = 0
var skill_data = {}
var unlocked = []
var blocked_skills = []
var scene
var button

func _ready() -> void:
	var file = FileAccess.open("res://Data/SkillData.json", FileAccess.READ)
	skill_data = JSON.parse_string(file.get_as_text())
	file.close()
	if FileAccess.file_exists(SAVE_LOCATION_SKILLS):
		var check_file = FileAccess.open(SAVE_LOCATION_SKILLS, FileAccess.READ)
		if check_file and check_file.get_length() > 0:
			check_file.close()
			load_data()
			return
		if check_file:
			check_file.close()
	save_data()
	scene = get_tree().current_scene
	if scene:
		update_colors_recursive(scene)

func i_dont_even_know_what_to_name_this():
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
	if is_bought(id) or id in blocked_skills:
		return false
	for req in skill_data[id]["Requirements"]:
		if req == null:
			return true
		elif !is_bought(req):
			return false
	return true

func buy(id):
	if id == "SkillButton5" or id == "SkillButton6" or id == "SkillButton14" or id == "SkillButton16":
		scene = get_tree().current_scene
		var found_button = find_node_by_name(scene, str(id))
		if found_button != null:
			var parent = found_button.get_parent()
			var children = parent.get_children()
			for child in children:
				if child.name != id:
					blocked_skills.append(child.name)
	var cost = int(skill_data[id]["Cost"])
	if !is_available(id) or wallet < cost:
		return false
	wallet -= cost
	unlocked.append(id)
	buy_color(id)
	save_data()
	var any_available = false
	for skill_id in skill_data:
		if is_available(skill_id):
			any_available = true
			if !BadgesManager.unlocked_badges.has("First Discovery"):
				BadgesManager.unlock_badge("First Discovery")
	if !any_available:
		if !BadgesManager.unlocked_badges.has("Mastermind"):
			BadgesManager.unlock_badge("Mastermind")
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
	i_dont_even_know_what_to_name_this()

func save_data():
	var skill_data_dict = []
	for skill in skill_data:
			skill_data_dict.append({
				"skill_name": skill,
				"is_bought": is_bought(skill),
				"is_available": is_available(skill)
			})
	var save_dict = {
		"skills": skill_data_dict,
		"blocked_skills": blocked_skills
	}
	var file = FileAccess.open(SAVE_LOCATION_SKILLS, FileAccess.WRITE)
	file.store_string(JSON.stringify(save_dict))
	file.close()

func load_data():
	if !FileAccess.file_exists(SAVE_LOCATION_SKILLS):
		return
	var file = FileAccess.open(SAVE_LOCATION_SKILLS, FileAccess.READ)
	if file == null:
		return
	var text = file.get_as_text()
	file.close()
	if file == null:
		return
	var data = JSON.parse_string(text)
	if data == null or not data is Dictionary:
		return
	scene = get_tree().current_scene
	unlocked.clear()
	blocked_skills.clear()
	if data.has("skills"):
		for skill_info in data["skills"]:
			var skill_name = skill_info["skill_name"]
			if skill_info["is_bought"]:
				unlocked.append(skill_name)
	if data.has("blocked_skills"):
		blocked_skills = data["blocked_skills"]
	update_colors_recursive(scene)

func get_multiplier(effect_name):
	var value = 1.0
	for id in unlocked:
		if skill_data[id]["Effect"] == effect_name: 
			value = float(skill_data[id]["Value"])
	return value

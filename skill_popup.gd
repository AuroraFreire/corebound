extends Node2D

const SAVE_LOCATION = "user://SaveFile.json"
var skill_data = {}
@onready var label_name = $UI/ItemPopup/Control/RichTextLabel2
@onready var label_description = $UI/ItemPopup/Control/RichTextLabel
@onready var label_cost = $UI/ItemPopup/Control/RichTextLabel3
@onready var base_popup_size = %ItemPopup.size

func _ready() -> void:
	var file = FileAccess.open("res://Data/SkillData.json", FileAccess.READ)
	skill_data = JSON.parse_string(file.get_as_text())
	file.close()

func skill_poup(skill: Rect2i, id, zoom: float = 1.0):
	var name = skill_data[id]["Name"]
	var description = skill_data[id]["Description"]
	var cost = int(skill_data[id]["Cost"])
	label_name.text = name
	label_description.text = description
	label_cost.text = "Cost: " + str(cost)
	var min_popup_zoom = 0.7
	var popup_zoom = max(zoom, min_popup_zoom)
	var inner = $UI/ItemPopup/Control
	inner.scale = Vector2.ONE * popup_zoom
	var scaled_size = Vector2(base_popup_size) * popup_zoom
	var padding = 8 * popup_zoom
	var correction = -Vector2i(scaled_size.x + padding, 0)
	%ItemPopup.popup(Rect2i(skill.position + correction, Vector2i(scaled_size)))

func hide_skill_popup():
	%ItemPopup.hide()

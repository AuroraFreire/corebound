extends Node

var item_data: Dictionary
var recipe_data: Array

func _ready() -> void:
	item_data = LoadData("res://Data/ItemData.json")
	recipe_data = LoadData("res://Data/CraftingRecipes.json")

func LoadData(file_path):
	var file_data = FileAccess.open(file_path, FileAccess.READ)
	var json_data = JSON.parse_string(file_data.get_as_text())
	file_data.close()
	return json_data

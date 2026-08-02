class_name FloatingText
extends Node2D

signal emit_spawn_text

@export var text_label: PackedScene = null

var current_text : String = ""
var current_icon : Texture2D = null

func _ready() -> void:
	emit_spawn_text.connect(spawn_text)

func set_text(new_text: String):
	current_text = new_text

func set_icon(new_icon: Texture2D):
	current_icon = new_icon

func spawn_text():
	var new_text_label = text_label.instantiate() as Label
	add_child(new_text_label)
	new_text_label.text = current_text
	new_text_label.get_node("TextureRect").texture = current_icon
	new_text_label.global_position = global_position
	current_icon = null

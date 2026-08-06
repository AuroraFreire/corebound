extends Node

@onready var home_animation = $"../../HomeBannerAnim"

func _on_texture_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/lab.tscn")

func _on_texture_button_mouse_entered() -> void:
	home_animation.play("home_banner_down")

func _on_texture_button_mouse_exited() -> void:
	home_animation.play("home_banner_up")

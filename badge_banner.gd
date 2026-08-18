extends Node2D

@onready var badge_animation = $"../../BadgeBannerAnim"

func _on_texture_button_mouse_entered() -> void:
	badge_animation.play("badge_banner_down")

func _on_texture_button_mouse_exited() -> void:
	badge_animation.play("badge_banner_up")

func _on_texture_button_pressed() -> void:
	$"../Badges".visible = true
	$"..".process_mode = Node.PROCESS_MODE_PAUSABLE
	$"../Badges".process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true

extends Node2D

@onready var animation_home = $HomeBannerAnim

func _on_home_banner_mouse_entered() -> void:
	animation_home.play("home_banner_down")

func _on_home_banner_mouse_exited() -> void:
	animation_home.play("home_banner_up")

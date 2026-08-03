extends Node2D

@onready var animation_home = $HomeBannerAnim

func _input(event: InputEvent) -> void:
	close_game(event)

func close_game(event: InputEvent) -> void:
	if event.is_action_pressed("close_game"):
		get_tree().quit()


func _on_home_banner_mouse_entered() -> void:
	animation_home.play("home_banner_down")


func _on_home_banner_mouse_exited() -> void:
	animation_home.play("home_banner_up")

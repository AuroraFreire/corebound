extends Node2D

func _ready() -> void:
	$Label2.visible = false
	$Panel.visible = false

func _on_play_pressed() -> void:
	if !IsFinished.isFinished:
		get_tree().change_scene_to_file("res://scenes/world1.tscn")
	else:
		$Label2.visible = true
		await get_tree().create_timer(2).timeout
		$Label2.visible = false

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_settings_pressed() -> void:
	$Panel.visible = true
	$RichTextLabel.visible = false
	$Play.visible = false
	$Settings.visible = false
	$Exit.visible = false
	$Label2.visible = false

func _on_button_pressed() -> void:
	$Panel.visible = false
	$RichTextLabel.visible = true
	$Play.visible = true
	$Settings.visible = true
	$Exit.visible = true

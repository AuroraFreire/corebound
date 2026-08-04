extends Node2D

func _ready() -> void:
	$DoorInteract.visible = false
	$TreeInteract.visible = false

func _input(event: InputEvent) -> void:
	interact(event)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "CharacterBody2D":
		$DoorInteract.visible = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "CharacterBody2D":
		$DoorInteract.visible = false


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body.name == "CharacterBody2D":
		$TreeInteract.visible = true

func _on_area_2d_2_body_exited(body: Node2D) -> void:
	if body.name == "CharacterBody2D":
		$TreeInteract.visible = false

func interact(event: InputEvent):
	if event.is_action_pressed("interact") and $DoorInteract.visible == true:
		get_tree().change_scene_to_file("res://scenes/world1.tscn")
	elif event.is_action_pressed("interact") and $TreeInteract.visible == true:
		get_tree().quit()

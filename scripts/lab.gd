extends Node2D

static var saved_position := Vector2.ZERO
static var has_saved_position := false

func _ready() -> void:
	$TreeInteract.visible = false
	$DoorInteract.visible = false
	if has_saved_position:
		$CharacterBody2D.global_position = saved_position
	
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

func _on_area_2d_3_body_entered(body: Node2D) -> void:
	if body.name == "CharacterBody2D":
		$SellInteract.visible = true

func _on_area_2d_3_body_exited(body: Node2D) -> void:
	if body.name == "CharacterBody2D":
		$SellInteract.visible = false

func interact(event: InputEvent):
	if event.is_action_pressed("interact") and $DoorInteract.visible:
		get_tree().change_scene_to_file("res://scenes/world1.tscn")
	elif event.is_action_pressed("interact") and $TreeInteract.visible:
		saved_position = $CharacterBody2D.global_position
		has_saved_position = true
		get_tree().change_scene_to_file("res://scenes/skill_tree.tscn")

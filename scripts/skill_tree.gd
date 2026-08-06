extends Node2D

@export var zoom_speed = 0.05
@export var min_zoom = 0.3
@export var max_zoom = 2.0
@export var drag_speed = 1.5
@onready var camera = $Camera2D
var isPressed = false
var isAvailable
var isPurchased
var e = Vector2.ZERO

func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and isPressed:
		e = event.relative * drag_speed
		camera.position -= e
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			isPressed = event.pressed
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			camera.zoom = Vector2.ONE * min(max_zoom, camera.zoom.x + zoom_speed)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			camera.zoom = Vector2.ONE * max(min_zoom, camera.zoom.x - zoom_speed)
	if event.is_action_pressed("close_tree"):
		get_tree().change_scene_to_file("res://scenes/lab.tscn")

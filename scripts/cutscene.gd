extends Node2D

@onready var animation1 = $AnimationPlayer
@onready var animation2 = $AnimationPlayer2
@onready var animation3 = $AnimationPlayer3
@onready var animation4 = $AnimationPlayer4
@onready var label1 = $"Panel/RichTextLabel"
@onready var label2 = $"Panel/RichTextLabel2"
@onready var label3 = $"Panel/RichTextLabel3"
@onready var label4 = $"Panel/RichTextLabel4"

func _ready() -> void:
	label1.visible = true
	animation1.play("text goes texty")
	await animation1.animation_finished
	label1.visible = false
	label2.visible = true
	animation2.play("text goes texty 2")
	await animation2.animation_finished
	label2.visible = false
	label3.visible = true
	animation3.play("text goes texty 3")
	await animation3.animation_finished
	label3.visible = false
	label4.visible = true
	animation4.play("text goes texty 4")
	await get_tree().create_timer(3.0).timeout
	get_tree().change_scene_to_file("res://main_menu.tscn")
	IsFinished.isFinished = true

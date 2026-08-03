extends CharacterBody2D

const MAX_SPEED = 66.6
const ACCEL = 250
const FRICTION = 400

@onready var player = $AnimatedSprite2D

var input = Vector2.ZERO

func _physics_process(delta: float) -> void:
	player_movement(delta)

func get_input():
	input.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	input.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	return input.normalized()

func player_movement(delta):
	input = get_input()
	if input == Vector2.ZERO:
		if velocity.length() > (FRICTION * delta):
			player.play("running_right")
			velocity -= velocity.normalized() * (FRICTION * delta)
		else:
			velocity = Vector2.ZERO
			player.play("idle")
	else:
		velocity += (input * ACCEL * delta)
		velocity = velocity.limit_length(MAX_SPEED)
		player.play("running_right")
		if input.x != 0:
			player.flip_h = input.x < 0
	move_and_slide()
	

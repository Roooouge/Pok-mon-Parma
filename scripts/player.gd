extends CharacterBody2D

const SPEED = 25.0

@onready var animation = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	
	var hor = Input.get_axis("move_left", "move_right")
	var ver = Input.get_axis("move_up", "move_down")
	
	if hor == 0:
		animation.play("idle_down")
	elif hor == -1:
		animation.play("walk-left");
	elif hor == 1:
		animation.play("walk-right");
	
	if ver == -1:
		animation.play("walk-up")
	elif ver == 1:
		animation.play("walk-down")
	
	if hor:
		velocity.x = hor * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if ver:
		velocity.y = ver * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
		
	move_and_slide()

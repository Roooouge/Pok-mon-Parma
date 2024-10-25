extends CharacterBody2D

var walk_speed = 4.0
const TILE_SIZE = 16

var init_pos = Vector2.ZERO
var dir = Vector2.ZERO
var is_moving = false
var percent_move_to_next_tile = 0.0

@onready var animation = $AnimatedSprite2D

# Called when the node enters the scene for the first time
func _ready() -> void:
	init_pos = position

func _physics_process(delta: float) -> void:
	if !is_moving:
		process_input()
		idle_anim()
	elif dir != Vector2.ZERO:
		move(delta)
	else:
		is_moving = false
		idle_anim()

func process_input() -> void:
	if dir.y == 0:
		dir.x = Input.get_axis("move_left", "move_right")
	if dir.x == 0:
		dir.y = Input.get_axis("move_up", "move_down")
	
	if dir != Vector2.ZERO:
		init_pos = position
		is_moving = true

func move(delta: float) -> void:
	percent_move_to_next_tile += walk_speed * delta
	if percent_move_to_next_tile >= 1.0:
		position = init_pos + (TILE_SIZE * dir)
		percent_move_to_next_tile = 0
		is_moving = false
		idle_anim()
	else:
		position = init_pos + (TILE_SIZE * dir * percent_move_to_next_tile)
		walk_anim()

func walk_anim() -> void:
	if dir == Vector2(-1,0):
		animation.play("walk-left")
	elif dir == Vector2(1,0):
		animation.play("walk-right")
	elif dir == Vector2(0,-1):
		animation.play("walk-up")
	elif dir == Vector2(0,1):
		animation.play("walk-down")

func idle_anim() -> void:
	animation.stop()
	if dir == Vector2(-1,0):
		animation.play("idle-left")
	elif dir == Vector2(1,0):
		animation.play("idle-right")
	elif dir == Vector2(0,-1):
		animation.play("idle-up")
	elif dir == Vector2(0,1):
		animation.play("idle-down")

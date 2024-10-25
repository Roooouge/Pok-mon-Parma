extends CharacterBody2D

const SPEED = 32.0
const TICKS = 4

@onready var animation = $AnimatedSprite2D



var curr_dir = -1
var curr_hor = 0
var curr_ver = 0

var tick = 0

func _physics_process(_delta: float) -> void:
	var hor = Input.get_axis("move_left", "move_right")
	var ver = Input.get_axis("move_down", "move_up")
	
	if hor == 0 && ver == 0:
		if curr_dir != -1:
			move()
			return
	
	if curr_dir == -1:
		if hor != 0 && ver != 0:
			return
			
		curr_hor = hor
		curr_ver = ver
		
		if ver == -1:
			curr_dir = 0 #down
		elif ver == 1:
			curr_dir = 1 #up
		elif hor == -1:
			curr_dir = 2 #left
		elif hor == 1:
			curr_dir = 3 #right
	
	move()
	
func move() -> void:	
	var anim_name = ""
	
	match curr_dir:
		-1:
			return
		0:
			anim_name = "walk_down"
			velocity.y = +SPEED
			velocity.x = 0
		1:
			anim_name = "walk_up"
			velocity.y = -SPEED
			velocity.x = 0
		2:
			anim_name = "walk_left"
			velocity.x = -SPEED
			velocity.y = 0
		3:
			anim_name = "walk_right"
			velocity.x = +SPEED
			velocity.y = 0
	
	tick = tick + 1
	
	print(tick, " - ", anim_name)
	animation.play(anim_name)
	move_and_slide()
	
	if tick == TICKS:
		end_move()

func end_move() -> void:
	
	tick = 0
	curr_dir = -1

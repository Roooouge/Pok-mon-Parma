extends CharacterBody2D

##### MOVEMENTS
var walk_speed = 4.0
const TILE_SIZE = 16

var init_pos = Vector2.ZERO
var dir = Vector2.ZERO
var facing = Vector2.ZERO
var is_moving = false
var percent_move_to_next_tile = 0.0

var frame_switcher = 0
var first_play = false

@onready var animation = $AnimatedSprite2D
@onready var ray = $RayCast2D

##### SIGNALS
signal player_moving
signal player_stopped

func _ready() -> void:
	init_pos = position
	ray_line.width = 2
	ray_line.default_color = Color.RED

func _physics_process(delta: float) -> void:
	if !is_moving:
		first_play = true
		process_input()
		if is_moving:
			move(delta)
	elif dir != Vector2.ZERO:
		move(delta)
	else:
		is_moving = false

func process_input() -> void:
	#checking movements
	if dir.y == 0:
		dir.x = Input.get_axis("move_left", "move_right")
	if dir.x == 0:
		dir.y = Input.get_axis("move_up", "move_down")
	
	if dir != Vector2.ZERO:
		init_pos = position
		is_moving = true
	
	#checking facing only if not moving
	if !is_moving:
		if facing.y == 0:
			facing.x = Input.get_axis("face_left", "face_right")
		if facing.x == 0:
			facing.y = Input.get_axis("face_up", "face_down")
		
		if facing != Vector2.ZERO:
			idle_anim(facing)
			facing = Vector2.ZERO

func move(delta: float) -> void:
	var desire_step: Vector2 = dir * (TILE_SIZE + 1) / 2
	ray.target_position = desire_step
	ray.force_raycast_update()
	
	if ray.is_colliding():
		percent_move_to_next_tile = 0
		is_moving = false
		idle_anim(dir)
		return
	
	if percent_move_to_next_tile == 0:
		emit_signal("player_moving")
		
	percent_move_to_next_tile += walk_speed * delta
	if percent_move_to_next_tile >= 1.0:
		position = init_pos + (TILE_SIZE * dir)
		percent_move_to_next_tile = 0
		is_moving = false
		emit_signal("player_stopped")
		
		if !still_pressing():
			idle_anim(dir)
		
	else:
		position = init_pos + (TILE_SIZE * dir * percent_move_to_next_tile)
		walk_anim()
		if first_play:
			check_frame_switcher()
			first_play = false

func still_pressing() -> bool:
	return Input.get_axis("move_left", "move_right") == 0 && Input.get_axis("move_up", "move_down")

func check_frame_switcher() -> void:
	animation.set_frame_and_progress(2 * frame_switcher, 0.0)
	frame_switcher = 0 if frame_switcher == 1 else 1

func walk_anim() -> void:
	var anim_name = ""
	if dir == Vector2(-1,0):
		anim_name = "walk-left"
	elif dir == Vector2(1,0):
		anim_name = "walk-right"
	elif dir == Vector2(0,-1):
		anim_name = "walk-up"
	elif dir == Vector2(0,1):
		anim_name = "walk-down"
	
	animation.play(anim_name)

func idle_anim(_dir: Vector2) -> void:
	animation.stop()
	
	var anim_name = ""
	if _dir == Vector2(-1,0):
		anim_name = "idle-left"
	elif _dir == Vector2(1,0):
		anim_name = "idle-right"
	elif _dir == Vector2(0,-1):
		anim_name = "idle-up"
	elif _dir == Vector2(0,1):
		anim_name = "idle-down"
	
	animation.play(anim_name)

##### Utilities #####

@onready var ray_line = $RayCast2D/Line2D

# Add this function at the beginning of _physics_process() to draw the collision detection raycast
func draw_ray_line() -> void:
	ray_line.points = [Vector2.ZERO, ray.target_position]

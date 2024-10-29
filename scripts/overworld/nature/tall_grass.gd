extends Node2D

const overlay_texture = preload("res://assets/entities/overworld/tall-grass-overlay.png")
var overlay: TextureRect = null
var is_player_inside: bool = false

func _ready() -> void:
	var player = get_tree().current_scene.find_child("Player")
	player.connect("player_stopped", self.player_inside)
	player.connect("player_moving", self.player_exiting)

func player_inside():
	print("Inside: ", is_player_inside)
	if is_player_inside:
		overlay = TextureRect.new()
		overlay.texture = overlay_texture
		overlay.rect_position = position
		get_tree().current_scene.add_child(overlay)

func player_exiting():
	is_player_inside = false
	if is_instance_valid(overlay):
		overlay.queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Entered")
	is_player_inside = true

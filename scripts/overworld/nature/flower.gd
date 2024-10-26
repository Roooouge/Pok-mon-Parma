extends AnimatedSprite2D

func _ready() -> void:
	randomize()

func _physics_process(_delta: float) -> void:
	var r = randi() % 5000
	
	if r == 0:
		play("default")

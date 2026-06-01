extends Area2D

const TILE_SIZE = 64
var can_move = false

func _ready():
	position = position.snapped(Vector2(TILE_SIZE, TILE_SIZE))

func _process(delta):
	if not can_move:
		return

	var direction = Vector2.ZERO
	
	if Input.is_action_just_pressed("ui_right"):
		direction = Vector2.RIGHT
	elif Input.is_action_just_pressed("ui_left"):
		direction = Vector2.LEFT
	elif Input.is_action_just_pressed("ui_down"):
		direction = Vector2.DOWN
	elif Input.is_action_just_pressed("ui_up"):
		direction = Vector2.UP

	if direction != Vector2.ZERO:
		position += direction * TILE_SIZE
		can_move = false


func _on_rhythm_timer_timeout():
	can_move = true
	print("Ruch")

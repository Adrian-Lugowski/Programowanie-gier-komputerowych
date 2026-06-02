extends Area2D

const TILE_SIZE = 64
var can_move = false

enum State { IDLE, CHARGING }
var current_state = State.IDLE

var charge_beats = 0
const REQUIRED_BEATS = 3

func _ready():

	position = position.snapped(Vector2(TILE_SIZE, TILE_SIZE))

func _process(delta):
	if current_state == State.CHARGING and Input.is_action_just_released("ui_accept"):
		if charge_beats >= REQUIRED_BEATS:
			print("Atak")
		else:
			print("Atak przerwany")
		
		current_state = State.IDLE
		charge_beats = 0
		$ColorRect.color = Color(0, 0, 1)

	if not can_move or current_state == State.CHARGING:
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
	if Input.is_action_pressed("ui_accept"):
		current_state = State.CHARGING
		charge_beats += 1
		print("Ładowanie: ", charge_beats, "/", REQUIRED_BEATS)
		
		$ColorRect.color = Color(1, 0, 0)
		can_move = false 
	else:
		can_move = true
		print(".")

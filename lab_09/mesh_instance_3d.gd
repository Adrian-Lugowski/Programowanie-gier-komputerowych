extends MeshInstance3D

const LIMIT_X = 5.0
const LIMIT_Y = 3.0
var move_speed = 10.0

func _process(delta):
	var input_dir = Vector2.ZERO
	
	if Input.is_action_pressed("ui_right"):
		input_dir.x += 1
	if Input.is_action_pressed("ui_left"):
		input_dir.x -= 1
	if Input.is_action_pressed("ui_up"):
		input_dir.y += 1
	if Input.is_action_pressed("ui_down"):
		input_dir.y -= 1
		
	position.x += input_dir.x * move_speed * delta
	position.y += input_dir.y * move_speed * delta
	
	position.x = clamp(position.x, -LIMIT_X, LIMIT_X)
	position.y = clamp(position.y, -LIMIT_Y, LIMIT_Y)

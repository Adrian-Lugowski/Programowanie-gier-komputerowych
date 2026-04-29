extends MeshInstance3D

const LIMIT_X = 5.0
const LIMIT_Y = 3.0
var move_speed = 10.0

@export var bullet_scene: PackedScene
var _shoot_cooldown: float = 0.0

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
	
	if _shoot_cooldown > 0:
		_shoot_cooldown -= delta
		
	if Input.is_action_just_pressed("ui_accept") and _shoot_cooldown <= 0:
		_shoot_cooldown = 0.3 
		
		var bullet = bullet_scene.instantiate()
		
		get_tree().root.add_child(bullet)
		
		bullet.global_position = global_position

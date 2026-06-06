extends Area2D

const TILE_SIZE = 64
var can_move = false

@onready var ray = $RayCast2D

enum State { IDLE, CHARGING }
var current_state = State.IDLE

enum Weapon { SWORD, HAMMER }
var current_weapon = Weapon.SWORD

var charge_beats = 0
const REQUIRED_BEATS = 3
var facing_direction = Vector2.RIGHT

var hp = 3
var player_xp = 0
var player_level = 1
var base_damage = 1

func _ready():
	position = position.snapped(Vector2(TILE_SIZE, TILE_SIZE))

func _process(delta):
	if Input.is_action_just_pressed("equip_sword"):
		current_weapon = Weapon.SWORD
		print("MIECZ")
	elif Input.is_action_just_pressed("equip_hammer"):
		current_weapon = Weapon.HAMMER
		print("MŁOT")
		
	# Atak młotem
	if current_state == State.CHARGING and Input.is_action_just_released("ui_accept"):
		if charge_beats >= REQUIRED_BEATS:
			print("Atak młotem")
			var all_enemies = get_tree().get_nodes_in_group("enemies")
			for enemy in all_enemies:
				if global_position.distance_to(enemy.global_position) <= TILE_SIZE * 1.5:
					if enemy.has_method("take_damage"):
						enemy.take_damage(base_damage + 1)
		else:
			print("Atak przerwany")
		
		current_state = State.IDLE
		charge_beats = 0
		$Sprite2D.modulate = Color(1, 1, 1)
		
	# Atak mieczem
	if current_state == State.IDLE and current_weapon == Weapon.SWORD and Input.is_action_just_pressed("ui_accept"):
		var attack_pos = global_position + (facing_direction * TILE_SIZE)
		print("Atak mieczem: ", facing_direction)
		var all_enemies= get_tree().get_nodes_in_group("enemies")
		for enemy in all_enemies:
			if enemy.global_position.distance_to(attack_pos) < 10:
				if enemy.has_method("take_damage"):
					enemy.take_damage(base_damage)
					
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
		facing_direction = direction
		var next_position = position + (direction * TILE_SIZE)
		var map_min_x = 0
		var map_min_y = 0
		var map_max_x = 2112
		var map_max_y = 1024
		if next_position.x >= map_min_x and next_position.x <= map_max_x and next_position.y >= map_min_y and next_position.y <= map_max_y:
			ray.target_position = direction * TILE_SIZE
			ray.force_raycast_update()
			if not ray.is_colliding():
				var tween = create_tween()
				tween.tween_property(self, "position", next_position, 0.1)
				can_move = false
			else:
				var uderzony_obiekt = ray.get_collider()
				print("Grid")
		else:
			print("Ściana")
			
func _on_rhythm_timer_timeout():
	if current_weapon == Weapon.HAMMER and Input.is_action_pressed("ui_accept"):
		current_state = State.CHARGING
		charge_beats += 1
		print("Ładowanie: ", charge_beats, "/", REQUIRED_BEATS)
		$Sprite2D.modulate = Color(1, 0, 0)
		can_move = false 
	else:
		can_move = true
		print("|")
		
func gain_xp(amount):
	player_xp += amount
	print("XP: ", player_xp, "/5")
	if player_xp >= 5:
		player_xp = 0
		player_level += 1
		base_damage += 1
		print("LEVEL: ", player_level, ". Obrażenia: ", base_damage)
		
func take_damage(amount):
	hp -= amount
	print("HP: ", hp)
	$Sprite2D.modulate = Color(1, 0, 0)
	await get_tree().create_timer(0.2).timeout
	$Sprite2D.modulate = Color(1, 1, 1)
	
	if hp <= 0:
		get_tree().call_deferred("change_scene_to_file", "res://game_over.tscn")
	

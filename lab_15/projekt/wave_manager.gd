extends Node

@export var enemy_scene: PackedScene 

var current_wave = 0
var is_spawning = false
const TILE_SIZE = 64

func _process(delta):
	if not is_spawning:
		var enemies = get_tree().get_nodes_in_group("enemies")
		if enemies.size() <= 0:
			if current_wave >= 5:
				win_game()
			else:
				start_next_wave()

func start_next_wave():
	is_spawning = true
	current_wave += 1
	print("Fala: ", current_wave)
	var hud = get_tree().get_first_node_in_group("hud")
	if hud:
		hud.update_wave(current_wave)
		
	await get_tree().create_timer(2.0).timeout
	var enemies_to_spawn = 2 + current_wave 
	for i in range(enemies_to_spawn):
		spawn_enemy()
		
	is_spawning = false

func spawn_enemy():
	if enemy_scene:
		var enemy = enemy_scene.instantiate()

		if "hp" in enemy:
			enemy.hp += current_wave 
		if "damage" in enemy:
			enemy.attack_damage += int(current_wave / 2.0)
			
		var spawn_points_node = get_parent().get_node_or_null("SpawnPoints")
		
		if spawn_points_node and spawn_points_node.get_child_count() > 0:
			var spawn_points = spawn_points_node.get_children()
			var random_spawn = spawn_points[randi() % spawn_points.size()]
			enemy.position = random_spawn.global_position
		else:
			var random_x = randi_range(2, 20) * TILE_SIZE
			var random_y = randi_range(2, 10) * TILE_SIZE
			enemy.position = Vector2(random_x, random_y)
		enemy.add_to_group("enemies")
		get_parent().add_child(enemy)

func win_game():
	is_spawning = true 
	get_tree().change_scene_to_file("res://win.tscn")

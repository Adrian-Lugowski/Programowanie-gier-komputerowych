extends Area2D

var hp = 2
const TILE_SIZE =64

func _ready():
	position = position.snapped(Vector2(TILE_SIZE, TILE_SIZE))

func take_damage(amaount):
	hp -= amaount
	print("Trawiony, zostało:", hp, "HP")
	
	if hp <= 0:
		print("Przeciwnik pokonany")
		var player = get_tree().get_first_node_in_group("player")
		if player:
			player.gain_xp(6)
			
		var enemies_left = get_tree().get_nodes_in_group("enemies").size()
		if enemies_left <= 1:
			get_tree().call_deferred("change_scene_to_file", "res://win.tscn")
			
		call_deferred("queue_free")
		
func _on_area_entered(area):
	if area.name == "Player":
		get_tree().call_deferred("change_scene_to_file", "res://game_over.tscn")
		
#func _on_rhythm_timer_timeout():
	var player = get_tree().get_first_node_in_group("player")
	
	if player:
		var direction_to_player = global_position.direction_to(player.global_position)
		var step = Vector2.ZERO
		
		if abs(direction_to_player.x) > abs(direction_to_player.y):
			step.x = sign(direction_to_player.x)
		else:
			step.y = sign(direction_to_player.y)
		
		position += step * TILE_SIZE

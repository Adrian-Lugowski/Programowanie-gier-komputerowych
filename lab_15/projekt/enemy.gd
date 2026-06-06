extends Area2D

var hp = 2
var damage = 1
var original_scale = Vector2.ONE
const TILE_SIZE = 64

var beat_counter = 0
var move_every_n_beats = 2

@onready var ray = $RayCast2D
@onready var sprite = $Sprite2D

func _ready():
	position = position.snapped(Vector2(TILE_SIZE, TILE_SIZE))
	
	if ray:
		ray.position = Vector2(TILE_SIZE / 2, TILE_SIZE / 2)
		
	var timer = get_tree().get_first_node_in_group("metronom")
	if timer:
		timer.timeout.connect(_on_rhythm_timer_timeout)
		
	if sprite:
		original_scale = sprite.scale

func take_damage(amount):
	hp -= amount
	print("Zostało:", hp, "HP")
	
	if sprite:
		sprite.modulate = Color(1, 0, 0)
		await get_tree().create_timer(0.2).timeout
		sprite.modulate = Color(1, 1, 1)
		
	var audio = get_tree().get_first_node_in_group("audio_manager")
	if audio:
		audio.play_hit()
		
	if hp <= 0:
		die()

func die():
	var audio = get_tree().get_first_node_in_group("audio_manager")
	if audio:
		audio.play_explode()
	print("Przeciwnik pokonany")
	var player = get_tree().get_first_node_in_group("player")
	if player and player.has_method("gain_xp"):
		player.gain_xp(6) 
		
	call_deferred("queue_free")

func _on_rhythm_timer_timeout():
	beat_counter += 1
	
	var player = get_tree().get_first_node_in_group("player")
	
	if beat_counter == move_every_n_beats - 1:
		if player:
			var direction = Vector2.ZERO
			var diff = player.position - position
			
			if abs(diff.x) > abs(diff.y):
				direction = Vector2.RIGHT if diff.x > 0 else Vector2.LEFT
			else:
				direction = Vector2.DOWN if diff.y > 0 else Vector2.UP
				
			if direction != Vector2.ZERO and ray:
				ray.target_position = direction * (TILE_SIZE * 0.8)
				ray.force_raycast_update()
				var tween = create_tween()
				tween.tween_property(sprite, "scale", original_scale * 1.2, 0.1)
				tween.tween_property(sprite, "scale", original_scale, 0.1)
				if ray.is_colliding():
					var collider = ray.get_collider()
					if collider and collider.is_in_group("player"):
						warn_player()
		return
	
	if beat_counter < move_every_n_beats:
		return
	
	beat_counter = 0
	
	if sprite:
		sprite.modulate = Color(1, 1, 1)
		sprite.scale = original_scale
	
	if player:
		var direction = Vector2.ZERO
		var diff = player.position - position
		
		if abs(diff.x) > abs(diff.y):
			direction = Vector2.RIGHT if diff.x > 0 else Vector2.LEFT
		else:
			direction = Vector2.DOWN if diff.y > 0 else Vector2.UP
			
		if direction != Vector2.ZERO:
			var target_pos = position + (direction * TILE_SIZE)
			
			var is_occupied_by_friend = false
			var all_enemies = get_tree().get_nodes_in_group("enemies")
			
			for other_enemy in all_enemies:
				if other_enemy != self and other_enemy.position == target_pos:
					is_occupied_by_friend = true
					break
					
			if not is_occupied_by_friend:
				if ray:
					ray.target_position = direction * (TILE_SIZE * 0.8)
					ray.force_raycast_update()
					
					if not ray.is_colliding():
						var tween = create_tween()
						tween.tween_property(self, "position", target_pos, 0.15)
					else:
						var collider = ray.get_collider()
						if collider and collider.is_in_group("player"):
							print("Przeciwnik atakuje!")
							if collider.has_method("take_damage"):
								collider.take_damage(damage)
								
func warn_player():
	if sprite:
		sprite.modulate = Color(1.0, 0.6, 0.0) 
		
		var tween = create_tween()
		tween.tween_property(sprite, "scale", original_scale * 1.2, 0.1)
		tween.tween_property(sprite, "scale", original_scale, 0.1)
		
func set_difficulty(wave_num):
	damage = 1 + (wave_num - 1)
	hp += wave_num

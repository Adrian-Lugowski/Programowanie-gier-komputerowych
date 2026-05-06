extends Node3D

@export var hp: int = 2
@export var speed: float = 3.0
@export var score_value: int = 100
@export var sway_amplitude: float = 2.0
@export var sway_period: float = 2.0
@export var shoot_interval: float = 2.5
@export var enemy_bullet_scene: PackedScene
var _shoot_timer: float = 0.0

signal died(points: int)

func _ready():
	$Area3D.area_entered.connect(_on_area_entered)
	var start_x = position.x
	var tween = create_tween().set_loops()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT	)
	tween.tween_property(self, "position:x", start_x + sway_amplitude, sway_period / 2.0)
	tween.tween_property(self, "position:x", start_x - sway_amplitude, sway_period / 2.0)
	
func shoot_at_player():
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		var player = players[0]
		var dir = (player.global_position - global_position).normalized()
		
		if enemy_bullet_scene:
			var bullet = enemy_bullet_scene.instantiate()
			get_tree().root.add_child(bullet)
			bullet.global_position = global_position
			bullet.direction = dir
	
func _on_area_entered(area: Area3D):
	hp -= 1
	if hp <= 0:
		died.emit(score_value)
		queue_free()
		
func _process(delta):
	_shoot_timer -= delta
	if _shoot_timer <= 0:
		shoot_at_player()
		_shoot_timer = shoot_interval

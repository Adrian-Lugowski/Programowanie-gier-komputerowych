extends Node

@export var enemy_scene: PackedScene
@export var path_follow: PathFollow3D

var waves: Array = [
	{ "count": 3, "x_positions": [-3.0, 0.0, 3.0], "z_offset": -10.0, "delay": 2.0 },
	{ "count": 2, "x_positions": [-2.0, 2.0], "z_offset": -15.0, "delay": 6.0 },
	{ "count": 1, "x_positions": [0.0], "z_offset": -20.0, "delay": 10.0 }
]

var _spawned: Array[bool] = []
var _time_elapsed: float = 0.0
var _total_enemies: int = 0
var _enemies_defeated: int = 0

func _ready() -> void:
	for i in range(waves.size()):
		_spawned.append(false)
		_total_enemies += waves[i]["count"]

func _process(delta: float) -> void:
	_time_elapsed += delta
	for i in range(waves.size()):
		if not _spawned[i] and _time_elapsed >= waves[i]["delay"]:
			_spawn_wave(waves[i])
			_spawned[i] = true
			
func _spawn_wave(wave_data: Dictionary) -> void:
	for i in range(wave_data["count"]):
		var enemy = enemy_scene.instantiate()
		var x_position = wave_data["x_positions"][i]
		var z_offset = wave_data["z_offset"]
		enemy.position = path_follow.global_position + Vector3(x_position, 0, z_offset)
		get_tree().root.add_child(enemy)
		enemy.died.connect(GameManager.add_score)
		enemy.died.connect(_on_enemy_destroyed)

func _on_enemy_destroyed(_points: int) -> void:
	_enemies_defeated += 1

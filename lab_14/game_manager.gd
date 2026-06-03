extends Node

var score: int = 0
var lives: int = 3
var player_max_hp: int = 100
var player_hp: int = 100
var _sfx_score := AudioStreamPlayer.new()
var _sfx_hit := AudioStreamPlayer.new()
var _sfx_game_over := AudioStreamPlayer.new()

signal score_changed(new_score)
signal lives_changed(new_lives)
signal hp_changed(new_hp)
signal game_over
signal level_complete
signal enemy_killed
signal player_damaged

func _ready() -> void:
	add_child(_sfx_hit)
	add_child(_sfx_score)
	add_child(_sfx_game_over)
	
	_sfx_hit.stream = preload("res://assets/audio/hitHurt.wav")
	_sfx_score.stream = preload("res://assets/audio/explosion.wav")
	_sfx_game_over.stream = preload("res://assets/audio/synth.wav")
	
	player_damaged.connect(func(): _sfx_hit.play())
	enemy_killed.connect(func(): _sfx_score.play())
	game_over.connect(func(): _sfx_game_over.play())

func add_score(points: int) -> void:
	score += points
	score_changed.emit(score)
	enemy_killed.emit()

func player_hit(damage: int = 20) -> void:
	player_hp -= damage
	player_damaged.emit()
	hp_changed.emit(player_hp)
	
	if player_hp <= 0:
		lives -= 1
		lives_changed.emit(lives)
		player_hp = player_max_hp
		hp_changed.emit(player_hp)
		
		if lives <= 0:
			game_over.emit()

func reset() -> void:
	score = 0
	lives = 3
	player_hp = player_max_hp

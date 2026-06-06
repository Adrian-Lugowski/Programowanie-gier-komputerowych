extends Node

@onready var hit_player = $HitPlayer
@onready var explode_player = $ExplodePlayer
@onready var music_player = $MusicPlayer

func play_hit():
	hit_player.play()

func play_explode():
	explode_player.play()

func play_music():
	music_player.play()

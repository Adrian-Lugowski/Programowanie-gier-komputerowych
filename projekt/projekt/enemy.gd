extends Area2D

func _ready():
	position = position.snapped(Vector2(64, 64))

func _on_area_entered(area):
	if area.name == "Player":
		get_tree().change_scene_to_file("res://game_over.tscn")

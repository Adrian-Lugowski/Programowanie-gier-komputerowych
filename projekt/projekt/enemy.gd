extends Area2D

var hp = 2

func _ready():
	position = position.snapped(Vector2(64, 64))

func take_damage(amaount):
	hp -= amaount
	print("Trawiony, zostało:", hp, "HP")
	
	if hp <= 0:
		get_tree().change_scene_to_file("res://win.tscn")
		queue_free()

func _on_area_entered(area):
	if area.name == "Player":
		get_tree().change_scene_to_file("res://game_over.tscn")

extends Node3D

func _ready():
	$Area3D.area_entered.connect(_on_hit)

func _on_hit(_area: Area3D):
	print("trafiony!")
	
	var main_scene = get_tree().current_scene
	if main_scene.has_method("add_score"):
		main_scene.add_score()
		
	queue_free()

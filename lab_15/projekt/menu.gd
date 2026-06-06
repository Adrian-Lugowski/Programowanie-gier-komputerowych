extends Control

func _on_button_pressed():
	get_tree().change_scene_to_file("res://main.tscn")

func _ready():
	var title = $Label 
	title.pivot_offset = title.size / 2 
	
	var tween = create_tween().set_loops()
	tween.tween_property(title, "scale", Vector2(1.1, 1.1), 0.5).set_trans(Tween.TRANS_SINE)
	tween.tween_property(title, "scale", Vector2(1.0, 1.0), 0.5).set_trans(Tween.TRANS_SINE)


func _on_button_mouse_entered():
	$AudioStreamPlayer2D.play()

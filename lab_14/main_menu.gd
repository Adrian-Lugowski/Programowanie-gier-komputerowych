extends Control

func _on_button_pressed() -> void:
	GameManager.reset()
	get_tree().change_scene_to_file("res://main.tscn")

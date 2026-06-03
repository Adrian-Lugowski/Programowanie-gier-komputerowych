extends Control

func _ready() -> void:
	$FinalScoreLabel.text = "Wynik końcowy: %d" % GameManager.score

func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")

extends CanvasLayer

func _ready() -> void:
	GameManager.score_changed.connect(_on_score_changed)
	GameManager.lives_changed.connect(_on_lives_changed)
	GameManager.hp_changed.connect(_on_hp_changed)
	GameManager.game_over.connect(_on_game_over)
	GameManager.level_complete.connect(_on_level_complete)

	$ScoreLabel.text = "Wynik: %d" % GameManager.score
	$LivesLabel.text = "Życia: %d" % GameManager.lives
	$HPProgressBar.max_value = GameManager.player_max_hp
	$HPProgressBar.value = GameManager.player_hp
	
func _on_game_over() -> void:
	get_tree().change_scene_to_file("res://game_over.tscn")

func _on_level_complete() -> void:
	get_tree().change_scene_to_file("res://level_complete.tscn")

func _on_score_changed(new_score: int) -> void:
	$ScoreLabel.text = "Wynik: %d" % new_score

func _on_lives_changed(new_lives: int) -> void:
	$LivesLabel.text = "Życia: %d" % new_lives

func _on_hp_changed(new_hp: int) -> void:
	$HPProgressBar.value = new_hp


func _on_boss_died() -> void:
	GameManager.level_complete.emit()

extends Area2D

func _ready():
	position = position.snapped(Vector2(64, 64))

func _on_area_entered(area):
	if area.name == "Player":
		print("Koniec Gry")

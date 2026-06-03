extends Node3D


func _ready():
	await get_tree().create_timer(0.8).timeout
	queue_free()

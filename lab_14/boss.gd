extends Node3D

enum State { IDLE, ATTACK, RETREAT, DEATH }
var current_state: State = State.IDLE

@export var max_hp: int = 100
var hp: int = max_hp
var phase2_active: bool = false

@export var enemy_bullet_scene: PackedScene
@export var explosion_scene: PackedScene

signal died 

@onready var hitbox1 = $HitboxPhase1/CollisionShape3D
@onready var hitbox2 = $HitboxPhase2/CollisionShape3D

func _ready() -> void:
	hitbox1.disabled = false
	hitbox2.disabled = true
	_enter_state(State.IDLE)

func _enter_state(new_state: State) -> void:
	current_state = new_state
	match current_state:
		State.IDLE: _start_idle()
		State.ATTACK: _start_attack()
		State.RETREAT: _start_retreat()
		State.DEATH: _start_death()

func _start_idle() -> void:
	await get_tree().create_timer(2.0).timeout
	if current_state != State.DEATH:
		_enter_state(State.ATTACK)

func _start_attack() -> void:
	if enemy_bullet_scene:
		var bullet = enemy_bullet_scene.instantiate()
		get_tree().root.add_child(bullet)
		bullet.global_position = global_position
		bullet.direction = Vector3(0, 0, 1)

	var tween = create_tween()
	var start_x = position.x
	tween.tween_property(self, "position:x", start_x + 4.0, 2.0)
	tween.tween_property(self, "position:x", start_x - 4.0, 2.0)
	tween.tween_property(self, "position:x", start_x, 1.0)
	await tween.finished
	
	if current_state != State.DEATH:
		_enter_state(State.RETREAT)

func _start_retreat() -> void:
	var tween = create_tween()
	tween.tween_property(self, "position:z", position.z - 4.0, 1.5)
	await tween.finished
	
	if current_state != State.DEATH:
		_enter_state(State.ATTACK)

func _start_death() -> void:
	hide()
	hitbox1.set_deferred("disabled", true)
	hitbox2.set_deferred("disabled", true)

	if explosion_scene:
		var explosion = explosion_scene.instantiate()
		get_parent().add_child(explosion)
		explosion.global_position = global_position
		
	await get_tree().create_timer(1.0).timeout
	died.emit()
	queue_free()

func take_hit(damage: int) -> void:
	if current_state == State.DEATH:
		return
		
	hp -= damage
	print("Boss HP: ", hp)
	
	if hp <= max_hp / 2 and not phase2_active:
		phase2_active = true
		hitbox1.set_deferred("disabled", true)
		hitbox2.set_deferred("disabled", false)
		print("Faza 2: Hitbox zmieniony")

	if hp <= 0:
		_enter_state(State.DEATH)

func _on_hitbox_phase_1_area_entered(area: Area3D) -> void:
	if area.is_in_group("player_bullets"):
		take_hit(5)
		area.queue_free()

func _on_hitbox_phase_2_area_entered(area: Area3D) -> void:
	if area.is_in_group("player_bullets"):
		take_hit(15)
		area.queue_free()

extends CanvasLayer

@onready var hp_bar = $HPBar
@onready var weapon_icon = $PanelWeapon/WeaponIcon
@export var sword_texture: Texture2D
@export var hammer_texture: Texture2D
@onready var wave_label = $PanelWave/WaveLabel
@onready var hp_label = $HPBar/HPLabel
@onready var level_label = $PanelLevel/LevelLabel

func update_hp(new_hp):
	if hp_bar:
		hp_bar.value = new_hp
	if hp_label:
		var max_hp = int(hp_bar.max_value)
		hp_label.text = str(new_hp) + " / " + str(max_hp)
		
func set_max_hp(new_max):
	if hp_bar:
		hp_bar.max_value = new_max

func update_wave(wave_num):
	if wave_label:
		wave_label.text = "Fala: " + str(wave_num) + " / 5"

func update_weapon(weapon_type):
	if weapon_icon:
		if weapon_type == 0: 
			weapon_icon.texture = sword_texture
		else: 
			weapon_icon.texture = hammer_texture
		
		var tween = create_tween()
		weapon_icon.scale = Vector2(1.2, 1.2)
		tween.tween_property(weapon_icon, "scale", Vector2(1, 1), 0.2)
		
func update_level(new_level):
	if level_label:
		level_label.text = "Level: " + str(new_level)

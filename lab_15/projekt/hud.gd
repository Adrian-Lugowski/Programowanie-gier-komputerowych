extends CanvasLayer

@onready var hp_bar = $HPBar
@onready var wave_label = $WaveLabel

func update_hp(new_hp):
	if hp_bar:
		hp_bar.value = new_hp

func update_wave(wave_num):
	if wave_label:
		wave_label.text = "Fala: " + str(wave_num) + " / 5"

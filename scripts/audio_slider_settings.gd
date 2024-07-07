extends Control


@onready var audio_name_label = $HBoxContainer/AudioNameLabel as Label
@onready var audio_num_label = $HBoxContainer/AudioNumLabel as Label
@onready var h_slider = $HBoxContainer/HSlider as HSlider

@export_enum("Master", "Music", "SFX") var bus_name : String

var bus_index : int = 0

func _ready():
	
	get_bus_name_by_index()
	load_data()
	set_name_label_text()
	set_audio_num_label_text()


func load_data() -> void:
	match bus_name:
		"Master":
			_on_h_slider_value_changed(SettingsDataContainer.get_master_volume())
		"Music":
			_on_h_slider_value_changed(SettingsDataContainer.get_music_volume())
		"SFX":
			_on_h_slider_value_changed(SettingsDataContainer.get_SFX_volume())


func set_name_label_text() -> void:
	audio_name_label.text = str(bus_name) + " Volume"

func set_audio_num_label_text() -> void:
	audio_num_label.text = str(h_slider.value * 100) 

func get_bus_name_by_index() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)

func set_slider_value() -> void:
	h_slider.value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))
	set_audio_num_label_text()


func _on_h_slider_value_changed(value) -> void:
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	set_audio_num_label_text()
	
	match bus_index:
		0:
			SettingsSignalBus.emit_on_master_sound_set(value)
		1:
			SettingsSignalBus.emit_on_music_sound_set(value)
		2:
			SettingsSignalBus.emit_on_SFX_sound_set(value)

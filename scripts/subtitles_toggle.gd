extends Control


@onready var state_lable = $HBoxContainer/StateLable
@onready var check_button = $HBoxContainer/CheckButton


func _ready():
	load_data()
	check_button.button_pressed = SettingsDataContainer.get_subtitles_set()


func set_label_text(button_pressed : bool) -> void:
	if !button_pressed:
		state_lable.text = "Off"
	else:
		state_lable.text = "On"

func load_data() -> void:
	_on_check_button_toggled(SettingsDataContainer.get_subtitles_set())

func _on_check_button_toggled(toggled_on : bool) -> void:
	set_label_text(toggled_on)
	SettingsSignalBus.emit_on_subtitles_toggled(toggled_on)


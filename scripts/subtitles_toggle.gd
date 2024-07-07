extends Control


@onready var state_lable = $HBoxContainer/StateLable
@onready var check_button = $HBoxContainer/CheckButton



func set_label_text(button_pressed : bool) -> void:
	if !button_pressed:
		state_lable.text = "Off"
	else:
		state_lable.text = "On"


func _on_check_button_toggled(toggled_on : bool) -> void:
	set_label_text(toggled_on)
	SettingsSignalBus.emit_on_subtitles_toggled(toggled_on)


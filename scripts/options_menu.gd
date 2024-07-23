extends Control

class_name OptionsMenu

@onready var exit_button = $MarginContainer2/ExitButton as Button
@onready var settings_tab_container = $MarginContainer/VBoxContainer/SettingsTabContainer as SettingsTabContainer
@onready var exit_text_animation = $MarginContainer2/ExitButton/ExitTextAnimation
@onready var options_title = $OptionsTitle




signal exit_options_menu # sends this signal which i connect to the main menu to run a function to close the options tab.

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false) #just a precaution so no buttons can be pressed from the options menu while it is not showing
	settings_tab_container.exit_settings_tab.connect(_on_exit_button_button_up)
	options_title.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_exit_button_button_up():
	exit_options_menu.emit() # sends the signal
	SettingsSignalBus.emit_set_settings_dictionary(SettingsDataContainer.create_storage_dictionary())
	set_process(false) # once again turns off process so that no buttons from the options menu can be clicked

func make_text_white(object : AnimatedSprite2D) -> void:
	var white_tween = get_tree().create_tween()
	white_tween.tween_property(object, "self_modulate", Color.WHITE, 0.2)

func make_text_black(object : AnimatedSprite2D) -> void:
	var white_tween = get_tree().create_tween()
	white_tween.tween_property(object, "self_modulate", Color.BLACK, 0.2)


func _on_exit_button_mouse_entered():
	make_text_white(exit_text_animation)


func _on_exit_button_mouse_exited():
	make_text_black(exit_text_animation)

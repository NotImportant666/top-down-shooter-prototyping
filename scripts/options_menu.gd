extends Control

class_name OptionsMenu

@onready var exit_button = $MarginContainer/VBoxContainer/ExitButton as Button



signal exit_options_menu # sends this signal which i connect to the main menu to run a function to close the options tab.

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false) #just a precaution so no buttons can be pressed from the options menu while it is not showing


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_exit_button_button_up():
	exit_options_menu.emit() # sends the signal
	SettingsSignalBus.emit_set_settings_dictionary(SettingsDataContainer.create_storage_dictionary())
	set_process(false) # once again turns off process so that no buttons from the options menu can be clicked

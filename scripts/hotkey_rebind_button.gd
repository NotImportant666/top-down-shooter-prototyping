extends Control

class_name HotkeyRebindButton

@onready var label = $HBoxContainer/Label as Label
@onready var button = $HBoxContainer/Button as Button

@export var action_name : String = "up"



func _ready():
	set_process_unhandled_key_input(false) # ignores key inputs
	set_action_name() # call set action name function
	set_text_for_key() # call set text for key function
	load_keybinds()


func load_keybinds() -> void:
	rebind_action_key(SettingsDataContainer.get_keybind(action_name))

func set_action_name() -> void:
	label.text = "Unassigned" # sets the label text to unnasigned
	
	match action_name: # looks through all the texts and replaces certain texts with better looking texts, purely visual
		"up":
			label.text = "Move Up"
		"down":
			label.text = "Move Down"
		"left":
			label.text = "Move Left"
		"right":
			label.text = "Move Right"

func set_text_for_key() -> void:
	var action_events : Array = InputMap.action_get_events(action_name) # stores the action name of each event
	var action_event = action_events[0] # honestly have no idea what this does
	var action_keycode : String= OS.get_keycode_string(action_event.physical_keycode) # gets the string name of the event i guess
	
	button.text = "%s" % action_keycode # sets the button text to the string name of the event


func _on_button_toggled(toggled_on) -> void:
	if toggled_on: # checks if the button is toggled on
		button.text = "Press any key..." # sets the button text to this
		set_process_unhandled_key_input(toggled_on) # sets the process on or off depending on whatever the bool thats passed in is
		
		for i in get_tree().get_nodes_in_group("hotkey button"): # i have no clue what any of this does im ngl, just followed a tutorial for this shit
			if i.action_name != self.action_name:
				i.button.toggle_mode = false
				i.set_process_unhandled_key_input(false)
	else:
		for i in get_tree().get_nodes_in_group("hotkey button"):
				if i.action_name != self.action_name:
					i.button.toggle_mode = true
					i.set_process_unhandled_key_input(false)
		set_text_for_key()

func _unhandled_key_input(event) -> void: 
	rebind_action_key(event) # passes in whatever event is passed in on button press
	button.button_pressed = false # sets the button pressed to false


func rebind_action_key(event): # method that actually rebinds the key i guess, idk what to say here
	InputMap.action_erase_events(action_name)
	InputMap.action_add_event(action_name, event)
	SettingsDataContainer.set_keybind(action_name, event)
	
	set_process_unhandled_key_input(false)
	set_text_for_key()
	set_action_name()

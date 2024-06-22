extends Control

class_name MainMenu



## onready vars
@onready var black_fade = $FadeControl/BlackFade as ColorRect
@onready var play = $MarginContainer/HBoxContainer/VBoxContainer/Play as Button
@onready var options = $MarginContainer/HBoxContainer/VBoxContainer/Options as Button
@onready var quit = $MarginContainer/HBoxContainer/VBoxContainer/Quit as Button
@onready var black_fade_timer = $FadeControl/BlackFadeTimer as Timer
@onready var menu_ambience = $MenuAmbience as AudioStreamPlayer
@onready var options_menu = $OptionsMenu as OptionsMenu
@onready var margin_container = $MarginContainer as MarginContainer




## functions
func _ready(): # called when scene is loaded
	var alpha_tween = get_tree().create_tween() # create tween for black screen alpha
	alpha_tween.tween_property(black_fade, "modulate", Color(0,0,0,0), 2) # tween black screen alpha to zero over 2 seconds

func _process(delta):
	if Input.is_action_just_pressed("quit"):
		_on_quit_button_up()

func _on_play_button_up(): # called when play button is clicked
	black_fade_to_next_scene("res://scenes/Test_scene.tscn") #calls the fade function, test scene is passed in, could be level 1 in an actual game
	var sound_tween = get_tree().create_tween() # special tween for play button since this starts the game, don't want the ambience going for that
	sound_tween.tween_property(menu_ambience,"volume_db", -72, 2) # tween the ambience down to something really quiet

func _on_options_button_up(): # called when options button is clicked
	margin_container.visible = false
	options_menu.set_process(true)
	options_menu.visible = true

func _on_quit_button_up(): # called when quit button is clicked
	get_tree().quit() # just quit the game, nothing special

func black_fade_to_next_scene(desired_scene: String): # method used for fading between scenes. fades the screen to black and also delays the changing of the scene. Pass in the dsired scene you want to change to
	black_fade_timer.start()
	var alpha_tween = get_tree().create_tween()
	alpha_tween.tween_property(black_fade, "modulate", Color.BLACK, 2)
	await black_fade_timer.timeout
	get_tree().change_scene_to_file(desired_scene)

func _on_options_menu_exit_options_menu(): # called when exit button in options menu is pressed
	margin_container.visible = true
	options_menu.visible = false

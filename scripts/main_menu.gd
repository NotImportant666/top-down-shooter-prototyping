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
@onready var white_noise_2 = $Background/WhiteNoise2
@onready var title_animation = $"MarginContainer/VBoxContainer/Title Animation"
@onready var symbol = $MarginContainer/VBoxContainer/Symbol
@onready var play_text_animation = $MarginContainer/HBoxContainer/VBoxContainer/Play/PlayTextAnimation




## functions
func _ready(): # called when scene is loaded
	play_text_animations()
	ready_tweens()


func _process(delta):
	pass

func _on_play_button_up(): # called when play button is clicked and let go
	black_fade_to_next_scene("res://scenes/Test_scene.tscn") #calls the fade function, test scene is passed in, could be level 1 in an actual game
	var sound_tween : Tween = get_tree().create_tween() # special tween for play button since this starts the game, don't want the ambience going for that
	sound_tween.tween_property(menu_ambience,"volume_db", -72, 2) # tween the ambience down to something really quiet, makes the transition smoother

func _on_options_button_up(): # called when options button is clicked and let go
	margin_container.visible = false # hide the main menu 
	options_menu.set_process(true) # turn on the process function for the options menu so buttons can be clicked
	options_menu.visible = true # show the options menu

func _on_quit_button_up(): # called when quit button is clicked and let go
	get_tree().quit() # just quit the game, nothing special

func black_fade_to_next_scene(desired_scene: String): # method used for fading between scenes. fades the screen to black and also delays the changing of the scene. Pass in the dsired scene you want to change to
	black_fade_timer.start() # start a timer to fade in the black screen
	var alpha_tween : Tween = get_tree().create_tween()
	alpha_tween.tween_property(black_fade, "modulate", Color.BLACK, 2)
	await black_fade_timer.timeout # wait for the fade timer to go off to change the scene, this way the transition is smooth
	get_tree().change_scene_to_file(desired_scene) # change the scene to whatever scene you pass in

func _on_options_menu_exit_options_menu(): # called when exit button in options menu is pressed
	margin_container.visible = true # make the main menu visible
	options_menu.visible = false # hide the options menu


func play_text_animations() -> void:
	white_noise_2.play("default")
	title_animation.play("new_animation")
	play_text_animation.play("default")


func _on_play_mouse_entered():
	make_text_white(play_text_animation)
	

func _on_play_mouse_exited():
	make_text_black(play_text_animation)


func make_text_white(object : AnimatedSprite2D) -> void:
	var white_tween = get_tree().create_tween()
	white_tween.tween_property(object, "self_modulate", Color.WHITE, 0.2)

func make_text_black(object : AnimatedSprite2D) -> void:
	var white_tween = get_tree().create_tween()
	white_tween.tween_property(object, "self_modulate", Color.BLACK, 0.2)

func ready_tweens() -> void:
	var alpha_tween : Tween= get_tree().create_tween() # create tween for black screen alpha
	alpha_tween.tween_property(black_fade, "modulate", Color(0,0,0,0), 2) # tween black screen alpha to zero over 2 seconds
	var symbol_spin_tween : Tween = get_tree().create_tween()
	symbol_spin_tween.tween_property(symbol, "rotation", 20*PI, 400)




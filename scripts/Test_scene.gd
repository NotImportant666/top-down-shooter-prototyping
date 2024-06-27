extends Node


@onready var black_fade = $BlackFadeControl/BlackFade
@onready var crowd_escape_path = $CrowdEscapePath
@onready var player = $Player


func _ready():
	var alpha_tween : Tween = get_tree().create_tween() # create black fade tween
	alpha_tween.tween_property(black_fade, "modulate", Color(0,0,0,0), 2) # tween black screen to invisible
	crowd_escape_path.enabled = false # turn off the pathing region so enemies don't move, temporary solution
	intro_cutscene_play() # call cutscene function

func _process(delta):
	if Input.is_action_just_pressed("quit"): # check every frame if quit button is pressed
		get_tree().quit() # close program, change this to open pause menu in the future
	
	
func _on_player_shots_fired() -> void: # called when shots fired signal is emitted from player scene
	crowd_escape_path.enabled = true # turn on the pathing region so enemies start moving


func intro_cutscene_play() -> void: 
	#print("playing cutscene.")
	var all_actions = InputMap.get_actions() # store all the input actions
	for i in all_actions: # for every item stored in all_actions
		InputMap.action_erase_events(i) # erase the action
	
	player.TestCutscene() # call the TestCutscene method from player scene to play the animations
	
	await player.get_node("CutsceneAnimations/TestCutsceneAnimation").animation_finished # get the animationplayer node from the player scene and await it's animation_finished signal
	InputMap.load_from_project_settings() # load up the actions from the project settings once again, whatever they might be.

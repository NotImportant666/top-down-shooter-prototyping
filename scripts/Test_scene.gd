extends Node


@onready var black_fade = $BlackFadeControl/BlackFade
@onready var crowd_escape_path = $CrowdEscapePath
@onready var player = $Player


func _ready():
	var alpha_tween = get_tree().create_tween()
	alpha_tween.tween_property(black_fade, "modulate", Color(0,0,0,0), 2)
	crowd_escape_path.enabled = false
	intro_cutscene_play()

func _process(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	
	
func _on_player_shots_fired():
	crowd_escape_path.enabled = true


func intro_cutscene_play():
	print("playing cutscene.")
	var all_actions = InputMap.get_actions()
	for i in all_actions:
		InputMap.action_erase_events(i)
	
	player.TestCutscene()
	
	await player.get_node("CutsceneAnimations/TestCutsceneAnimation").animation_finished
	InputMap.load_from_project_settings()

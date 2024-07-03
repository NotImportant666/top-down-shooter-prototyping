extends Node


@onready var black_fade = $BlackFadeControl/BlackFade
@onready var crowd_escape_path = $CrowdEscapePath
@onready var player = $Player
@onready var cutscene = $Cutscene
@onready var color_inversion = $ColorInversion

signal play_UI_animation


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
	cutscene.play("walk up talk")
	player.cutscene_started()
	await cutscene.animation_finished
	play_UI_animation.emit()
	await Input.is_action_just_pressed("shoot")
	cutscene.play("end")
	player.cutscene_ended()



func _on_player_invert_colors_signal():
	color_inversion.visible = true
	await get_tree().create_timer(0.05).timeout
	color_inversion.visible = false

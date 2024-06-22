extends Node


@onready var black_fade = $BlackFadeControl/BlackFade

func _ready():
	var alpha_tween = get_tree().create_tween()
	alpha_tween.tween_property(black_fade, "modulate", Color(0,0,0,0), 2)

func _process(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()


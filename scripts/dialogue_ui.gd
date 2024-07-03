extends CanvasLayer

@onready var bottom_rect = $Control/BottomRect
@onready var top_rect = $Control/TopRect
@onready var animation_player = $AnimationPlayer
@onready var dialogue_text = $Control/BottomRect/HBoxContainer/DialogueText

var i : int = 0
var all_dialogue : Array = [
"Let's kill these niggas",
"Left mouse button to shoot",
"E to interact with downed enemies",
" "
]

signal dialogue_ended



func _on_test_scene_play_ui_animation() -> void:
	animation_player.play("dialogue")
	await animation_player.animation_finished
	dialogue_text.text = all_dialogue[i]





func _on_player_continue_dialogue() -> void:
	if i == 3:
		animation_player.play("end dialogue")
		await animation_player.animation_finished
		dialogue_ended.emit()
	else:
		i = i + 1
		dialogue_text.text = all_dialogue[i]

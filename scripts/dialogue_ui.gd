extends CanvasLayer

@onready var bottom_rect = $Control/BottomRect
@onready var top_rect = $Control/TopRect
@onready var animation_player = $AnimationPlayer


func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_test_scene_play_ui_animation():
	animation_player.play("dialogue")

extends Sprite2D


@onready var animation_player = $AnimationPlayer





func _ready():
	var animation_list = animation_player.get_animation_list()
	var random_animation = animation_list[randi() % animation_list.size()]
	animation_player.play(random_animation)
	await animation_player.animation_finished
	queue_free()
	







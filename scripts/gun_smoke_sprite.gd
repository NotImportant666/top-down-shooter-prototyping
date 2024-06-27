extends Sprite2D


@onready var animation_player = $AnimationPlayer





func _ready():
	var animation_list : Array = animation_player.get_animation_list() # get the list of animations and put them in an array
	var random_animation : String = animation_list[randi() % animation_list.size()] # pick a random animation from that list
	animation_player.play(random_animation) # play the random animation
	await animation_player.animation_finished # wait for the animation to finish
	queue_free() # delete scene instance.
	







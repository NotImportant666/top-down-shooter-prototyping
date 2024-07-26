extends Sprite2D

@onready var animation_player = $AnimationPlayer
@onready var wall_collision_sound = $WallCollisionSound



# Called when the node enters the scene tree for the first time.
func _ready():
	
	animation_player.play("on hit")
	wall_collision_sound.play()
	await wall_collision_sound.finished
	queue_free()
	
	

extends Sprite2D

@onready var animation_player = $AnimationPlayer
@onready var body_collision_sound = $BodyCollisionSound

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("blood_animation")
	body_collision_sound.play()
	await body_collision_sound.finished
	queue_free()





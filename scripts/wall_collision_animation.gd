extends Sprite2D

@onready var animation_player = $AnimationPlayer
@onready var wall_collision_sound = $WallCollisionSound

@export var impact_sound : float

# Called when the node enters the scene tree for the first time.
func _ready():
	wall_collision_sound.volume_db = impact_sound
	animation_player.play("on hit")
	wall_collision_sound.play()
	await wall_collision_sound.finished
	queue_free()
	

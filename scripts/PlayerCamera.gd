extends Camera2D


@export var random_strength : float = 5.0
@export var shake_fade : float = 5.0
@onready var player = $".."

var rng = RandomNumberGenerator.new()

var shake_strength : float = 0.0

func apply_shake():
	shake_strength = random_strength

func _process(delta):
	var extension_direction = (get_global_mouse_position() - get_parent().global_position)
	var extension = extension_direction.normalized() * extension_direction.length() * 0.1
	clamp(extension, extension_direction.normalized(), extension_direction.normalized() * 10)
	
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength,0,shake_fade*delta)
		offset = extension + random_offset()
	elif shake_strength < 2:
		offset = lerp(offset, extension, delta * 8)
		
	
	



func random_offset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength,shake_strength),rng.randf_range(-shake_strength,shake_strength))

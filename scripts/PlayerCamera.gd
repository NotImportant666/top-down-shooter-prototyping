extends Camera2D


@export var random_strength : float = 5.0
@export var shake_fade : float = 5.0





var rng : RandomNumberGenerator = RandomNumberGenerator.new() # create a new random number generator

var shake_strength : float = 0.0

func _ready():
	pass

func apply_shake() -> void:
	shake_strength = random_strength # set the shake strength the the random strength

func _process(delta):
	var extension_direction : Vector2 = (get_global_mouse_position() - get_parent().global_position) # create the direction for the camera extension by getting the vector from the player to the mouse position
	var extension : Vector2 = extension_direction.normalized() * extension_direction.length() * 0.2 # the actual extenstion is the extention direction + 10% of the length of the direction
	clamp(extension, extension_direction.normalized(), extension_direction.normalized() * 10) # the extension can't be less that 1 but cant be more than 10 times the direction
	
	#this shit doesnt work for some reason
	if shake_strength > 0: 
		shake_strength = lerpf(shake_strength,0,shake_fade*delta) # interpolate the shake strength down to zero each frame
		offset = extension + random_offset() # the offset for the camera is the extension plus the random offset calculated from the helper function
	elif shake_strength < 1:
		offset = lerp(offset, extension, delta * 8)
		
	
	



func random_offset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength,shake_strength),rng.randf_range(-shake_strength,shake_strength)) # generates a random vector based on the ranges specified

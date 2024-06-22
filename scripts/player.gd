extends CharacterBody2D

@onready var body_sprite = $BodySprite
@onready var leg_sprite = $LegSprite
@onready var body_animations = $BodyAnimations
@onready var leg_animations = $LegAnimations
@onready var ray_cast_2d = $RayCast2D
@onready var firing_speed_timer = $FiringSpeedTimer
@onready var muzzle_flash = $MuzzleFlash
@onready var player_camera = $PlayerCamera


@export var tracer_bullet_scene : PackedScene


var speed = 200

var canShoot = true

func _physics_process(delta):
	
	## player movement =======================================================================================================================================================
	
	var direction = Input.get_vector("left","right","up","down") # create vector based on input
	
	look_at(get_global_mouse_position()) # makes scene look at the mouse
	
	velocity = direction * speed * delta # velocity is direction times speed, need this value for leg sprite rotation.
	
	leg_sprite.global_rotation = velocity.angle() # need to add specific global position so the legs don't rotate with the mouse
	
	position += velocity # updates the scene position
	
	move_and_slide()
	
	## player body animations =====================================================================================================================================================
	
	if Input.is_action_pressed("shoot"):
		body_animations.play("shooting")
		player_camera.apply_shake()
		if canShoot:
			shoot()
			muzzle_flash.visible = true
			canShoot = false
			firing_speed_timer.start()
		
	elif direction:
		body_animations.play("walking")
	else:
		body_animations.play("idle")
	
	## player leg animations =====================================================================================================================================================
	
	if direction:
		leg_animations.play("walking")
	else:
		leg_animations.play("idle")
	
	## Miscellanious processes =====================================================================================================================================================
	
	ray_cast_2d.rotation = randf_range(-deg_to_rad(3), deg_to_rad(3)) # rotates the raycast by a random angle with 6 degrees, used for random bullets pread.





func _on_firing_speed_timer_timeout():
	canShoot = true

func shoot():
	if ray_cast_2d.is_colliding():
		var collision_point = ray_cast_2d.get_collision_point()
		draw_tracer(collision_point)
		

func draw_tracer(point):
		var tracer_bullet_instance = tracer_bullet_scene.instantiate()
		get_tree().root.add_child(tracer_bullet_instance)
		tracer_bullet_instance.add_point(ray_cast_2d.global_position)
		tracer_bullet_instance.add_point(point)

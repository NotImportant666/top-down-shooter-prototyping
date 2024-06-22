extends CharacterBody2D

@onready var body_sprite = $BodySprite as AnimatedSprite2D
@onready var leg_sprite = $LegSprite as AnimatedSprite2D
@onready var body_animations = $BodyAnimations as AnimationPlayer
@onready var leg_animations = $LegAnimations as AnimationPlayer
@onready var ray_cast_2d = $RayCast2D as RayCast2D
@onready var firing_speed_timer = $FiringSpeedTimer as Timer
@onready var muzzle_flash = $MuzzleFlash as Sprite2D
@onready var player_camera = $PlayerCamera 
@onready var machine_gun_shoot = $MachineGunShoot as AudioStreamPlayer


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
		body_animations.play("shooting") # play shoot animation
		player_camera.apply_shake() # call shake function from player camera
		
		if !machine_gun_shoot.playing: # check if it's playing, if not, play the sound.
			machine_gun_shoot.play()
		
		
		if canShoot:
			shoot() # call shoot function
			muzzle_flash.visible = true  # makes muzzle flash node and it's children visible
			canShoot = false # set to false to regulate shot speed
			firing_speed_timer.start() # shot speed timer, can be changed for different weapons
		
	elif direction:
		machine_gun_shoot.stop()
		body_animations.play("walking")
	else:
		machine_gun_shoot.stop()
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

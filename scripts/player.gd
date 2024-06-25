extends CharacterBody2D

@onready var body_walk_sprite_strip = $BodyWalkSpriteStrip
@onready var leg_sprite_strip = $LegSpriteStrip
@onready var body_animations = $BodyAnimations 
@onready var leg_animations = $LegAnimations 
@onready var ray_cast_2d = $RayCast2D as RayCast2D
@onready var firing_speed_timer = $FiringSpeedTimer as Timer
@onready var muzzle_flash = $MuzzleFlash as Sprite2D
@onready var player_camera = $PlayerCamera 
@onready var machine_gun_shoot = $MachineGunShoot as AudioStreamPlayer
@onready var player = $"." as CharacterBody2D
@onready var test_cutscene_animation = $CutsceneAnimations/TestCutsceneAnimation
@onready var muzzle_flash_light = $MuzzleFlash/MuzzleFlashLight
@onready var muzzle_flash_shadow = $MuzzleFlash/MuzzleFlashShadow












@export var tracer_bullet_scene : PackedScene
@export var gun_smoke_sprite_scene : PackedScene
@export var direction : Vector2
@export var speed = 200

var canShoot = true
var cutsceneIsPlaying = true

signal shots_fired



func _ready():
	pass
func _physics_process(delta):
	
	## player movement =======================================================================================================================================================
	if !cutsceneIsPlaying:
		direction = Input.get_vector("left","right","up","down") # create vector based on input
		look_at(get_global_mouse_position()) # makes scene look at the mouse
	else:
		rotation = direction.angle()
	
	velocity = direction * speed # velocity is direction times speed, need this value for leg sprite rotation.
	
	leg_sprite_strip.global_rotation = velocity.angle() # need to add specific global position so the legs don't rotate with the mouse
	
	move_and_slide()
	
	## player camera shit =====================================================================================================================================================
	
	
	
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
	
	ray_cast_2d.rotation = randf_range(-deg_to_rad(2), deg_to_rad(2)) # rotates the raycast by a random angle with 4 degrees, used for random bullets pread.
	
	
	
	## Light Detection =====================================================================================================================================================
	






func _on_firing_speed_timer_timeout():
	canShoot = true

func shoot():
	if ray_cast_2d.is_colliding():
		var collision_point = ray_cast_2d.get_collision_point()
		draw_tracer(collision_point)
		instantiate_smoke(muzzle_flash.global_position)
		
		if ray_cast_2d.get_collider().has_method("kill"):
			ray_cast_2d.get_collider().kill()
	
	shots_fired.emit()

func draw_tracer(point):
		var tracer_bullet_instance = tracer_bullet_scene.instantiate()
		get_tree().root.add_child(tracer_bullet_instance)
		tracer_bullet_instance.add_point(muzzle_flash.global_position)
		tracer_bullet_instance.add_point(point)

func instantiate_smoke(barrel_position):
	var gun_smoke_sprite_instance = gun_smoke_sprite_scene.instantiate()
	get_tree().root.add_child(gun_smoke_sprite_instance)
	gun_smoke_sprite_instance.global_position = barrel_position
	gun_smoke_sprite_instance.rotation = global_rotation - deg_to_rad(90)





func TestCutscene():
	cutsceneIsPlaying = true
	look_at(direction)
	test_cutscene_animation.play("walk up talk")
	await test_cutscene_animation.animation_finished
	cutsceneIsPlaying = false
	speed = 200
	

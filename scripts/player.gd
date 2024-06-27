class_name Player
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
@export var speed : float = 200

var canShoot : bool = true
var cutsceneIsPlaying : bool = true
var isInExecutionRange : bool = false
var isExecuting : bool = false

signal shots_fired

var execution_positions : Array = []


func _ready():
	pass

func _physics_process(delta):
	
	## player movement =======================================================================================================================================================
	if !cutsceneIsPlaying and !isExecuting:
		direction = Input.get_vector("left","right","up","down") # create vector based on input
		look_at(get_global_mouse_position()) # makes scene look at the mouse
	else:
		rotation = direction.angle()
	
	
	if !isExecuting:
		velocity = direction * speed # velocity is direction times speed, need this value for leg sprite rotation.
	else:
		velocity = Vector2.ZERO
	
	leg_sprite_strip.global_rotation = velocity.angle() # need to add specific global position so the legs don't rotate with the mouse
	
	move_and_slide() # so collision shapes collide and slide with others
	
	## execution shit =====================================================================================================================================================
	
	if Input.is_action_just_pressed("execute") and isInExecutionRange:
		isExecuting = true
		#global_position = execution_positions[0]
		#direction = execution_positions[0]
		
		
	if isExecuting and Input.is_action_just_pressed("shoot"):
		isExecuting = false
	
	
	
	## player body animations =====================================================================================================================================================
	
	if Input.is_action_pressed("shoot") and !isExecuting:
		body_animations.play("shooting") # play shoot animation
		player_camera.apply_shake() # call shake function from player camera
		
		if !machine_gun_shoot.playing: # check if it's playing, if not, play the sound.
			machine_gun_shoot.play()
		
		
		if canShoot:
			shoot() # call shoot function
			muzzle_flash.visible = true  # makes muzzle flash node and it's children visible
			canShoot = false # set to false to regulate shot speed
			firing_speed_timer.start() # shot speed timer, can be changed for different weapons
		
	elif direction and !isExecuting: # if direction is larger or less than zero
		machine_gun_shoot.stop() # stops shooting animation
		body_animations.play("walking") # start walking animation
	else: # if direction is equal to zero
		machine_gun_shoot.stop() # stop machine gun animation
		body_animations.play("idle") # play idle animation
	
	## player leg animations =====================================================================================================================================================
	
	if direction and !isExecuting: # if direction is larger or less than zero
		leg_animations.play("walking") # play walking animation
	else:
		leg_animations.play("idle") # play idle animation
	
	## Miscellanious processes =====================================================================================================================================================
	
	ray_cast_2d.rotation = randf_range(-deg_to_rad(2), deg_to_rad(2)) # rotates the raycast by a random angle with 4 degrees, used for random bullets pread.
	
	
	
	## Light Detection =====================================================================================================================================================
	






func _on_firing_speed_timer_timeout() -> void: # when firing speed timer reaches zero
	canShoot = true # shoot function can be called again

func shoot() -> void: # called when left mouse is pressed
	if ray_cast_2d.is_colliding(): # checks if raycast is colliding with anything
		var collision_point = ray_cast_2d.get_collision_point() # stores the point at which the raycas collides
		draw_tracer(collision_point) # call draw_tracer function and pass in said collision point
		instantiate_smoke(muzzle_flash.global_position) # call instantiate_smoke function and set the instance position to the muzzle flash postion
		
		var random_number = randi_range(1, 2) # create a random number for death checking each time the shoot function is called
		
		if random_number == 1: # 1 in 5 chance that enemy is knocked down rather than killed
			if ray_cast_2d.get_collider().has_method("knock_down"): # check if the collider has the knock_down method
				ray_cast_2d.get_collider().knock_down() # call that method
		else:
			if ray_cast_2d.get_collider().has_method("kill"): # check if the collider has kill method
				ray_cast_2d.get_collider().kill() # call the kill method
	
	shots_fired.emit() # emits the shots fired signal to activate enemy pathing

func draw_tracer(point) -> void:
		var tracer_bullet_instance = tracer_bullet_scene.instantiate() # instantiate the tracer scene
		get_tree().root.add_child(tracer_bullet_instance) # add it to the tree
		tracer_bullet_instance.add_point(muzzle_flash.global_position) # point one is the muzzle flash position (gun barrel)
		tracer_bullet_instance.add_point(point) # point two is the passed in collider position

func instantiate_smoke(barrel_position) -> void:
	var gun_smoke_sprite_instance = gun_smoke_sprite_scene.instantiate() # instantiate smoke scene
	get_tree().root.add_child(gun_smoke_sprite_instance) # add it to the tree
	gun_smoke_sprite_instance.global_position = barrel_position # set it's position to the muzzle flash position
	gun_smoke_sprite_instance.rotation = global_rotation - deg_to_rad(90) # rotate it by 90 degrees because the scene faces down rather than to the right.







func TestCutscene() -> void: # honestly don't know if this should be in the player scene. look_at and cutsceneisplaying maybe, but the play animation should probably be in the world scene somehow
	cutsceneIsPlaying = true # self explanatory
	look_at(direction) # makes the character look in the direction it's walking in so it isn't facing some random direction
	test_cutscene_animation.play("walk up talk") # play walk up talk animation
	await test_cutscene_animation.animation_finished # wait for the animation to finish
	cutsceneIsPlaying = false # self explanatory
	speed = 200 # set the speed to 200 again, gets all fucked up otherwise
	








func _on_execution_area_area_entered(area) -> void:
	print("entered")
	if area == get_tree().get_first_node_in_group("enemy").get_node("ExecutionBodyArea"):
		execution_positions.insert(0 ,area.global_position)
		
	isInExecutionRange = true
	print(execution_positions)


func _on_execution_area_area_exited(area) -> void:
	print("exited")
	if area == get_tree().get_first_node_in_group("enemy").get_node("ExecutionBodyArea"):
		execution_positions.erase(area.global_position)
		
	isInExecutionRange = false

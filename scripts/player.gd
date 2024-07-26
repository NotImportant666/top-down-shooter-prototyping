class_name Player
extends CharacterBody2D

@onready var body_walk_sprite_strip = $BodyWalkSpriteStrip
@onready var leg_sprite_strip = $LegSpriteStrip
@onready var body_animations = $BodyAnimations 
@onready var leg_animations = $LegAnimations 
@onready var machine_gun_raycast = $MachineGunRaycast as RayCast2D
@onready var firing_speed_timer = $FiringSpeedTimer as Timer
@onready var muzzle_flash = $MuzzleFlash as Sprite2D
@onready var player_camera = $PlayerCamera as Camera2D
@onready var gunshot_sound = $GunSounds/GunshotSound as AudioStreamPlayer
@onready var player = $"." as CharacterBody2D
@onready var muzzle_flash_light = $MuzzleFlash/MuzzleFlashLight
@onready var muzzle_flash_shadow = $MuzzleFlash/MuzzleFlashShadow
@onready var ejection_point = $EjectionPoint
@onready var bullet_cases_dropping = $GunSounds/BulletCasesDropping
@onready var bullet_cases_dropping_end = $GunSounds/BulletCasesDroppingEnd
@onready var shotgun_raycast_system = $ShotgunRaycastSystem
@onready var gunshot_end = $GunSounds/GunshotEnd

















@export var sprites : PlayerTextureResource
@export var tracer_bullet_scene : PackedScene
@export var gun_smoke_sprite_scene : PackedScene
@export var Enemy_on_hit_blood_animation : PackedScene
@export var obstacle_on_hit_animation : PackedScene
@export var bullet_casing_scene : PackedScene
@export var direction : Vector2
@export var speed : float = 100
@export var camera_zoom : Vector2

@export_enum("shotgun", "machine gun") var current_weapon : int




var canShoot : bool = true
var isShooting : bool = false
var cutsceneIsPlaying : bool = true
var isInExecutionRange : bool = false
var isExecuting : bool = false


signal shots_fired
signal call_execution_method
signal call_mutilation_method
signal invert_colors_signal
signal continue_dialogue

var execution_positions : Array = []
var execution_rotations : Array = []
var enemy_instance : CharacterBody2D
var shotgun_bullet_collision_points : Array = []




func _ready():
	match current_weapon:
		0:
			gunshot_sound.stream = load("res://Real Assets/sounds/gun sounds/AA12 gunshots.ogg")
			bullet_cases_dropping.stream = load("res://Real Assets/sounds/gun sounds/shotgun shells dropping.mp3")
			bullet_cases_dropping_end.stream = load("res://Real Assets/sounds/gun sounds/shotgun shells dropping end.mp3")
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("bullet impacts"), -16) 
			shotgun_raycast_system.visible = true
		1:
			gunshot_sound.stream = load("res://assets/HOTLINE MIAMI STOLEN ASSETS/SOUNDS/player sounds/clean-machine-gun-burst-98224.mp3")
			bullet_cases_dropping.stream = load("res://Real Assets/sounds/gun sounds/bullet cases dropping.mp3")
			bullet_cases_dropping_end.stream = load("res://Real Assets/sounds/gun sounds/bullet cases dropping ending.mp3")
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("bullet impacts"), -5) 
			shotgun_raycast_system.visible = false




func _physics_process(delta):
	
	## player movement =======================================================================================================================================================
	if !cutsceneIsPlaying and !isExecuting:
		direction = Input.get_vector("left","right","up","down") # create vector based on input
		look_at(get_global_mouse_position()) # makes scene look at the mouse
	elif isExecuting:
		direction = Vector2(-1,0).rotated(execution_rotations[0])
		rotation = direction.angle()
	else:
		rotation = direction.angle()
	
	
	if !isExecuting:
		velocity = direction * speed # velocity is direction times speed, need this value for leg sprite rotation.
	else:
		velocity = Vector2.ZERO
	
	leg_sprite_strip.global_rotation = velocity.angle() # need to add specific global position so the legs don't rotate with the mouse
	
	move_and_slide() # so collision shapes collide and slide with others
	
	## execution shit =====================================================================================================================================================
	
	if Input.is_action_just_pressed("execute") and isInExecutionRange: # if E gets pressed while the ExecutionArea overlaps with an enmy area, run the cote
		isExecuting = true # is in execution state
		global_position = execution_positions[0] # set position the execution are for a smooth transition into a different animation
		#player.visible = false # make player invisible so i can play the execution animation instead
		
	
	if isExecuting and Input.is_action_just_pressed("shoot"): # If E has been pressed while in an execution area, click shoot to execute and exit execution state
		isExecuting = false # no longer in the execution state
		player.visible = true # player is visible again
		call_execution_method.emit(enemy_instance) # this emits the signal to call the exection method in the enemy scene. That method basically just spawns blood and will
		invert_colors_signal.emit()
	
	if isExecuting and Input.is_action_just_pressed("alt shoot"):
		call_mutilation_method.emit(enemy_instance)
	
	
	
	## player body animations =====================================================================================================================================================
	
	if Input.is_action_pressed("shoot") and !isExecuting and !cutsceneIsPlaying:
		isShooting = true
		body_animations.play("LMG shooting") # play shoot animation
		
		
		
		
		
		if canShoot:
			match current_weapon:
				0:
					firing_speed_timer.wait_time = 0.2
					player_camera.apply_shake() # call shake function from player camera
					
					
					play_gun_sounds()
					shotgun_shoot_function()
				1:
					firing_speed_timer.wait_time = 0.1
					player_camera.apply_shake() # call shake function from player camera
					
					
					play_gun_sounds()
					machine_gun_shoot_function()
			
			muzzle_flash.visible = true  # makes muzzle flash node and it's children visible
			canShoot = false # set to false to regulate shot speed
			firing_speed_timer.start() # shot speed timer, can be changed for different weapons
		
		
		
		
	elif direction and !isExecuting and !isShooting : # if direction is larger or less than zero
		gunshot_sound.stop() # stops shooting sound
		bullet_cases_dropping.stop()
		body_animations.play("walking") # start walking animation
	elif !isShooting: # if direction is equal to zero
		gunshot_sound.stop() # stop machine gun sound
		bullet_cases_dropping.stop()
		body_animations.play("idle") # play idle animation
	
	## player leg animations =====================================================================================================================================================
	
	if direction and !isExecuting: # if direction is larger or less than zero
		leg_animations.play("walking") # play walking animation
	else:
		leg_animations.play("idle") # play idle animation
	
	## Miscellanious processes =====================================================================================================================================================
	
	machine_gun_raycast.rotation = randf_range(-deg_to_rad(5), deg_to_rad(5)) # rotates the raycast by a random angle with 4 degrees, used for random bullets pread.
	
	player_camera.zoom = camera_zoom # sets the player camera zoom each physics frame, this is so i can change the zoom with an animation player and it will be updated
	
	## Dialogue Interaction =====================================================================================================================================================
	
	if cutsceneIsPlaying and Input.is_action_just_pressed("shoot"):
		continue_dialogue.emit()






func _on_firing_speed_timer_timeout() -> void: # when firing speed timer reaches zero
	canShoot = true # shoot function can be called again
	isShooting = false
	if !Input.is_action_pressed("shoot"):
		gunshot_end.play()
		bullet_cases_dropping_end.play()

func machine_gun_shoot_function() -> void: # called when left mouse is pressed
	if machine_gun_raycast.is_colliding(): # checks if raycast is colliding with anything
		var collision_point = machine_gun_raycast.get_collision_point() # stores the point at which the raycas collides
		draw_tracer(collision_point) # call draw_tracer function and pass in said collision point
		instantiate_smoke(muzzle_flash.global_position) # call instantiate_smoke function and set the instance position to the muzzle flash postion
		instantiate_bullet_casing_ejection(ejection_point.global_position)
		decide_if_enemy_killed_or_knocked_over(machine_gun_raycast)
		bullet_collision_effect(machine_gun_raycast.get_collision_point())
		
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

func instantiate_bullet_collision_effect(desired_effect: PackedScene,collision_point: Vector2) -> void:
	var effect_instance = desired_effect.instantiate()
	get_tree().root.add_child(effect_instance)
	effect_instance.global_position = collision_point
	effect_instance.rotation = (global_position - collision_point).angle() + deg_to_rad(180)

func instantiate_bullet_casing_ejection(ejection_position : Vector2) -> void:
	var bullet_casing_instance = bullet_casing_scene.instantiate()
	get_tree().root.add_child(bullet_casing_instance)
	bullet_casing_instance.global_position = ejection_position
	bullet_casing_instance.global_rotation = rotation

func cutscene_started() -> void: # honestly don't know if this should be in the player scene. look_at and cutsceneisplaying maybe, but the play animation should probably be in the world scene somehow
	cutsceneIsPlaying = true # self explanatory

func cutscene_ended() -> void:
	cutsceneIsPlaying = false

func _on_execution_area_area_entered(area) -> void:
	
	enemy_instance = area.get_parent()
	execution_positions.insert(0 ,area.global_position)
	execution_rotations.insert(0, area.global_rotation)
	isInExecutionRange = true

func _on_execution_area_area_exited(area) -> void:
	execution_positions.erase(area.global_position)
	execution_rotations.erase(area.global_rotation)
	isInExecutionRange = false

func randomize_muzzle_flash_parameters() -> void:
	var random_number = randf_range(-0.1, 0.1)
	muzzle_flash.scale = muzzle_flash.scale + Vector2(random_number, random_number)

func shotgun_shoot_function() -> void:
	
	var individual_shotgun_raycasts = shotgun_raycast_system.get_all_raycasts()
	if machine_gun_raycast.is_colliding():
		shotgun_bullet_collision_points = shotgun_raycast_system.get_all_raycast_collision_points()
		for i in shotgun_bullet_collision_points:
			draw_tracer(i)
			bullet_collision_effect(i)
		
		
		for i in individual_shotgun_raycasts:
			decide_if_enemy_killed_or_knocked_over(i)
		
		
		instantiate_smoke(muzzle_flash.global_position) # call instantiate_smoke function and set the instance position to the muzzle flash postion
		instantiate_bullet_casing_ejection(ejection_point.global_position)
	shotgun_bullet_collision_points.clear()

func bullet_collision_effect(collision_point : Vector2) -> void:
	if machine_gun_raycast.get_collider().is_in_group("enemy"):
		instantiate_bullet_collision_effect(Enemy_on_hit_blood_animation, collision_point)
	
	else:
		instantiate_bullet_collision_effect(obstacle_on_hit_animation, collision_point)

func decide_if_enemy_killed_or_knocked_over(given_raycast : RayCast2D) -> void:
	var random_number = randi_range(1, 5) # create a random number for death checking each time the shoot function is called
	
	if random_number == 1: # 1 in 5 chance that enemy is knocked down rather than killed
		if given_raycast.get_collider().has_method("knock_down"): # check if the collider has the knock_down method
			given_raycast.get_collider().knock_down() # call that method
	else:
		if given_raycast.get_collider().has_method("kill"): # check if the collider has kill method
			given_raycast.get_collider().kill() # call the kill method
			invert_colors_signal.emit()

func play_gun_sounds() -> void:
	if !gunshot_sound.playing: # check if it's playing, if not, play the sound.
		gunshot_sound.play()
		bullet_cases_dropping.play()

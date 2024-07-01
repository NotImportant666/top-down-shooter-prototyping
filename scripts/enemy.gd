extends CharacterBody2D
class_name Enemy

@export var blood_scene : PackedScene
@export var sprites : TextureResource = null
@export var dead : bool = false
@export var knocked_down : bool = false 

var speed : float = 200


@onready var animation_player = $AnimationPlayer
@onready var navigation_agent_2d = $NavigationAgent2D
@onready var player : CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var leg_walk_sprite_strip = $LegWalkSpriteStrip
@onready var body_walk_sprite_strip = $BodyWalkSpriteStrip
@onready var dead_sprite = $DeadSprite
@onready var execution_body_area = $ExecutionBodyArea
@onready var enemy = $"."




var target_reached : bool



 

func _ready(): # called when the scene opens
	leg_walk_sprite_strip.texture = sprites.Leg_texture # set leg animations to whatever resource the scene currently has
	body_walk_sprite_strip.texture = sprites.Body_texture # set body animations to whatever resource the scene currently has
	dead_sprite.texture = sprites.Dead_texture # set dead texture to whatever resource the scene has
	
	
	animation_player.play("RESET") # idk why i did this, i guess so they dont look dead or something for a single frame
	
	await get_tree().physics_frame # wait for the physics frame to be setup and shit, needed because otherwise there's an error
	call_deferred("actor_setup") # call the actor setup function



func actor_setup() -> void: # goofy ahh helper function i dont even know what it does really. i get the gist but not enough to explain it
	navigation_agent_2d.target_position = get_tree().root.get_node("TestScene/CrowdEscapePath/Obstacles/door").global_position # gets the parent of the enemy node (current world scene) and then gets the desired node path



func _physics_process(delta):
	
	if dead or knocked_down: #return if dead or knocked down, so they dont move if dead
		return
	
	# set direction to next path position and set velocity
	var direction : Vector2 = (navigation_agent_2d.get_next_path_position() - global_position).normalized() # creates a base vector for the enemy which is just the direction to the next path position
	velocity = direction * speed # sets the velocity to the direction times the specified speed
	if direction: # if direction is not zero then the rotation is the angle of the direction vector
		global_rotation = direction.angle() # set scene rotation to the angle of the direction vector
	else: # if direction is zero just look at the player, this will be changed in the future
		global_rotation = global_position.direction_to(player.global_position).angle() # get the direction to the player and then get the angle of that direction
	move_and_slide() # called so it collides and slides on other collision shapes
	
	
	if direction: # if direction is not zero, play the walking animation
		animation_player.play("walking") # play walking animation
	else: # if direction is zero play the idle animation
		animation_player.play("idle") # play idle animation
	



func kill() -> void: # gets called 4 out of 5 times the player raycast collides and player clicks left mouse
	if dead or knocked_down: # skip over if already dead
		return
	dead = true # set dead state to true so it isn't called multiple times
	animation_player.play("killed") # play death animation
	global_rotation = global_position.direction_to(player.global_position).angle() # set rotation to player so it looks like momentum is preserved. will be changed to independent animations in the future
	add_blood_instance_to_tree(blood_scene, enemy, player, deg_to_rad(180))


func knock_down() -> void: # gets called 1 fifth of the time when the player raycast collides and player clicks left mouse
	if knocked_down: # skip over if already knocked down
		return
	knocked_down = true # set knocked down state to true so it doesnt get called multiple times
	global_rotation = global_position.direction_to(player.global_position).angle() # set rotation to player so it looks like momentum is preserved. will be changed to independent animations in the future
	animation_player.play("killed") # play death animation
	await animation_player.animation_finished # await for said animation to finish
	animation_player.play("knocked down") # play the knocked down animation which just flashes the color to indicate you can execute them

func execute() -> void: # called when enemy is knocked down, player is in execution range, player clicks E followed by player clicking left mouse.
	if dead:
		return
	dead = true
	animation_player.play("execute1")
	add_blood_instance_to_tree(blood_scene, execution_body_area, player, deg_to_rad(180))


func mutilate() -> void:
	add_blood_instance_to_tree(blood_scene, execution_body_area, player, deg_to_rad(180))



func _on_navigation_agent_2d_navigation_finished() -> void: # called when they reach their position
	queue_free() # delete the instance


func _on_player_call_execution_method(passed_in_enemy_instance : CharacterBody2D) -> void:
	passed_in_enemy_instance.execute()


func add_blood_instance_to_tree(desired_instance: PackedScene, desired_body, desired_look_at_body: CharacterBody2D, extra_rotation: float) -> void:
	var instance = desired_instance.instantiate()
	get_tree().root.add_child(instance)
	instance.global_position = desired_body.global_position
	instance.rotation = desired_body.global_position.direction_to(desired_look_at_body.global_position).angle()


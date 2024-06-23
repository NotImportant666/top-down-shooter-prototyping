extends CharacterBody2D
class_name Enemy


var speed = 200

@onready var animation_player = $AnimationPlayer
@onready var navigation_agent_2d = $NavigationAgent2D
@onready var player : CharacterBody2D = get_tree().get_first_node_in_group("player")

var dead

var target_reached

func _ready():
	animation_player.play("RESET")
	call_deferred("actor_setup")
	


func actor_setup():
	await get_tree().physics_frame
	navigation_agent_2d.target_position = get_parent().get_node("CrowdEscapePath/Obstacles/door").global_position # gets the parent of the enemy node (current world scene) and then gets the desired node path



func _physics_process(delta):
	
	if dead: #return if dead
		return
	
	# set direction to next path position and set velocity
	var direction = (navigation_agent_2d.get_next_path_position() - global_position).normalized()
	velocity = direction * speed
	global_rotation = direction.angle()
	move_and_slide()
	
	#set animation to walk if direction is anything but vector zero
	if direction:
		animation_player.play("walking")
	else:
		animation_player.play("idle")
	
	

func kill():
	if dead:
		return
	dead = true
	animation_player.play("killed")
	global_rotation = global_position.direction_to(player.global_position).angle()



func _on_navigation_agent_2d_navigation_finished(): #called when they reach their position
	queue_free()

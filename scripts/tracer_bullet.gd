extends Line2D

@onready var tracer_bullet = $"."





# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready():
	var alpha_tween : Tween = get_tree().create_tween() # create a tween for the alpha of the tracer.
	alpha_tween.tween_property(tracer_bullet, "modulate:a", 0, 0.5) # tween tracer to invisible
	await get_tree().create_timer(1).timeout # create a time for 1 second and wait for it to time out
	queue_free() # delete tracer instance
	


extends Line2D

@onready var tracer_bullet = $"."





# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var alpha_tween = get_tree().create_tween()
	alpha_tween.tween_property(tracer_bullet, "modulate:a", 0, 0.5)
	await get_tree().create_timer(0.7).timeout
	queue_free()


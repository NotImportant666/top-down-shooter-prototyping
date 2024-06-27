extends CPUParticles2D





func _on_blood_process_timer_timeout(): # on timer timeout it sets all of these processes to flase.
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
	set_process_internal(false)
	set_process_unhandled_input(false)
	set_process_unhandled_key_input(false)

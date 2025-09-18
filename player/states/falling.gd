extends BipedalState


func input_update(event: InputEvent):
	if event.is_action_pressed("jump"):
		if not player.coyote_time.is_stopped():
			change_state("Jumping")
		else:
			player.jump_buffer.start()
	else:
		super(event)


func physics_update(delta: float):
	super(delta)
	
	if player.is_on_floor():
		if not player.jump_buffer.is_stopped():
			change_state("Jumping")
		elif Input.get_vector("down", "up", "right", "left") != Vector2.ZERO:
			change_state("Run")
		else:
			change_state("Idle")

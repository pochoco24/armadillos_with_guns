extends BallState


func input_update(event: InputEvent):
	if event.is_action_pressed("jump"):
		if not player.coyote_time.is_stopped():
			change_state("Jumping")
		else:
			player.jump_buffer.start()
	else:
		super(event)


func physics_update(delta: float) -> void:
	super(delta)
	
	if ball.on_floor:
		if not player.jump_buffer.is_stopped():
			player.jump_buffer.stop()
			change_state("Jumping")
		else:
			change_state("Rolling")

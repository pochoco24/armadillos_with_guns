extends BallState


func input_update(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		change_state("Jumping")
	else:
		super(event)


func physics_update(delta: float):
	super(delta)
	
	if not ball.on_floor:
		player.coyote_time.start()
		change_state("Falling")

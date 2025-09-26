extends BipedalState


func enter():
	player.anim.play("Idle")


func input_update(event: InputEvent) -> void:
	if Input.get_vector("left", "right", "up", "down") != Vector2.ZERO:
		change_state("Run")
	elif event.is_action_pressed("jump"):
		change_state("Jumping")
	else:
		super(event)


func physics_update(delta: float):
	if not player.is_on_floor():
		player.coyote_time.start()
		change_state("Falling")
	
	super(delta)

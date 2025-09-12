extends BipedalState


func input_update(event: InputEvent) -> void:
	if Input.get_vector("left", "right", "up", "down") != Vector2.ZERO:
		change_state("Run")
	elif event.is_action_pressed("jump"):
		change_state("Jumping")
	else:
		super(event)


func physics_update(delta: float):
	var velocity_flat = Vector2(player.velocity.x, player.velocity.z)
	
	velocity_flat = velocity_flat.move_toward(Vector2.ZERO, player.acceleration)
	
	player.velocity.x = velocity_flat.x
	player.velocity.z = velocity_flat.y
	
	player.velocity.y -= player.gravity
	
	player.move_and_slide()
	
	if not player.is_on_floor():
		player.coyote_time.start()
		change_state("Falling")
	
	super(delta)

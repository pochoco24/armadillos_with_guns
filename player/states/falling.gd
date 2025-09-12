extends BipedalState


func input_update(event: InputEvent):
	if event.is_action("jump"):
		if not player.coyote_time.is_stopped():
			change_state("Jumping")
		else:
			player.jump_buffer.start()


func physics_update(delta: float):
	var input_dir = Input.get_vector("left", "right", "up", "down")
	
	# Rotate with camera
	var input_dir_world = input_dir.rotated(-player.cam_pivot.rotation.y)
	
	var velocity_flat = Vector2(player.velocity.x, player.velocity.z)
	
	velocity_flat = velocity_flat.move_toward(
			input_dir_world * player.speed, player.acceleration)
	
	player.velocity.x = velocity_flat.x
	player.velocity.z = velocity_flat.y
	
	player.velocity.y -= player.gravity
	
	player.move_and_slide()
	
	if player.is_on_floor():
		if not player.jump_buffer.is_stopped():
			player.jump_buffer.stop()
			change_state("Jumping")
		elif Input.get_vector("down", "up", "right", "left") != Vector2.ZERO:
			change_state("Run")
		else:
			change_state("Idle")
	
	super(delta)

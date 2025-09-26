class_name BipedalState
extends PlayerState


func input_update(event: InputEvent):
	if event.is_action_pressed("ball_mode"):
		change_state("Ball")


func physics_update(delta: float):
	var input_dir = Input.get_vector("left", "right", "up", "down")
	
	# Rotate with camera
	var input_dir_world = input_dir.rotated(-player.cam_pivot.rotation.y)
	
	# Rotate character to input direction
	if input_dir_world != Vector2.ZERO:
		player.rotation.y = lerp_angle(
				player.rotation.y, -input_dir_world.angle() + PI/2.0, player.rotation_speed)
	
	var velocity_flat = Vector2(player.velocity.x, player.velocity.z)
	
	velocity_flat = velocity_flat.move_toward(
			input_dir_world * player.speed, player.acceleration)
	
	player.velocity.x = velocity_flat.x
	player.velocity.z = velocity_flat.y
	
	player.velocity.y -= player.gravity
	
	player.move_and_slide()
	
	player.cam_pivot.position = player.position

extends BipedalState

@export var jump_speed: float


func enter():
	player.velocity.y = jump_speed
	player.jump_buffer.stop()
	player.coyote_time.stop()


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
	
	if player.velocity.y < 0.0:
		change_state("Falling")
	
	super(delta)

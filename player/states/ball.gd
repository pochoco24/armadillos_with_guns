extends PlayerState

@export var ball: RigidBody3D 
@export var acceleration: float
@export var jump_speed: float

var was_on_floor = false


func enter():
	player.mesh.visible = false
	player.set_collision_layer_value(1, false)
	player.set_collision_mask_value(1, false)
	player.set_collision_mask_value(2, false)
	
	ball.visible = true
	ball.set_collision_layer_value(1, true)
	ball.set_collision_mask_value(1, true)
	ball.set_collision_mask_value(2, true)
	ball.freeze = false
	
	ball.position = player.position
	ball.linear_velocity = player.velocity


func exit():
	player.mesh.visible = true
	player.set_collision_layer_value(1, true)
	player.set_collision_mask_value(1, true)
	player.set_collision_mask_value(2, true)
	
	ball.visible = false
	ball.set_collision_layer_value(1, false)
	ball.set_collision_mask_value(1, false)
	ball.set_collision_mask_value(2, false)
	ball.freeze = true
	
	player.position = ball.position
	player.velocity = ball.linear_velocity


func input_update(event: InputEvent):
	if event.is_action_released("ball_mode"):
		if Input.get_vector("down", "up", "right", "left") != Vector2.ZERO:
			change_state("Run")
		else:
			change_state("Idle")


func physics_update(delta):
	
	var input_dir = Input.get_vector("left", "right", "up", "down")
	
	# Rotate with camera
	var input_dir_world = input_dir.rotated(-player.cam_pivot.rotation.y)
	
	var input_dir_3d = Vector3(input_dir_world.x, 0.0, input_dir_world.y)
	
	ball.apply_torque(Vector3.UP.cross(input_dir_3d) * acceleration)
	
	# Start Coyote Time
	if ball.on_floor != was_on_floor:
		if not ball.on_floor:
			player.coyote_time.start()
		was_on_floor = ball.on_floor
	
	# Jump with Jump Buffer
	if ball.on_floor and not player.jump_buffer.is_stopped():
		ball.apply_impulse(Vector3.UP * jump_speed) # Jump
		player.jump_buffer.stop()
	# Jump on floor or Coyote Time
	elif Input.is_action_just_pressed("jump"):
		if ball.on_floor or not player.coyote_time.is_stopped():
			ball.apply_impulse(Vector3.UP * jump_speed) # Jump
			player.jump_buffer.stop()
		else:
			player.jump_buffer.start()
	
	player.position = ball.position
	
	player.cam_pivot.position = ball.position

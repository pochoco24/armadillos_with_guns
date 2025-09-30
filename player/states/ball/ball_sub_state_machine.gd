extends SubStateMachine

@export var player: CharacterBody3D
@export var ball: RigidBody3D


func input_update(event: InputEvent) -> void:
	if event.is_action_released("ball_mode"):
		change_state("Falling")
	else:
		super(event)


func physics_update(delta: float) -> void:
	super(delta)
	
	var velocity_flat = Vector2(ball.linear_velocity.x, ball.linear_velocity.z)
	
	player.dust_particles.emitting = (
			velocity_flat.length() > player.min_speed_for_dust
			and ball.on_floor
	)


func enter():
	super()
	
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
	
	player.cam_pivot.change_fov(90.0)
	
	ball.on_floor = false
	set_substate("Falling")
	
	# Place particles right under ball
	player.dust_particles.position.y = -0.5


func exit():
	super()
	
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
	
	player.rotation.y = (
			-Vector2(ball.linear_velocity.x, ball.linear_velocity.z).angle() + PI/2.0
	)
	
	player.cam_pivot.change_fov(player.cam_pivot.default_fov)
	
	# Place particles right player
	player.dust_particles.position.y = -1

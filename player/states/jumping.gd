extends BipedalState

@export var jump_speed: float


func enter():
	player.velocity.y = jump_speed
	player.jump_buffer.stop()
	player.coyote_time.stop()


func physics_update(delta: float):
	super(delta)
	
	if player.velocity.y < 0.0:
		change_state("Falling")
	elif player.is_on_floor():
		if not player.jump_buffer.is_stopped():
			change_state("Jumping")
		elif Input.get_vector("down", "up", "right", "left") != Vector2.ZERO:
			change_state("Run")
		else:
			change_state("Idle")

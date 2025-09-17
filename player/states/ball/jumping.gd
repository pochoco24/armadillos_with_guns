extends BallState

@export var jump_speed: float


func enter():
	ball.apply_impulse(Vector3.UP * jump_speed)
	player.jump_buffer.stop()
	player.coyote_time.stop()


func physics_update(delta: float):
	super(delta)

	if ball.linear_velocity.y < 0.0:
		change_state("Falling")

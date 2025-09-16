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

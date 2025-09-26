extends BipedalState

@export var jump_speed: float


func enter():
	player.velocity.y = jump_speed
	player.jump_buffer.stop()
	player.coyote_time.stop()
	
	player.anim.play("Jumping")


func physics_update(delta: float):
	super(delta)
	
	if player.velocity.y < 0.0:
		change_state("Falling")
	elif player.is_on_floor() and not player.velocity.y > 0.0:
		# Check if player is on floor AND that player isn't already jumping
		# this avoids double jump when the player exits ball and is clipping a bit
		# through the floor.
		# If you intend to add moving platforms that move up in the future
		# you may want to change this approach.
		
		if not player.jump_buffer.is_stopped():
			change_state("Jumping")
		elif Input.get_vector("down", "up", "right", "left") != Vector2.ZERO:
			change_state("Run")
		else:
			change_state("Idle")

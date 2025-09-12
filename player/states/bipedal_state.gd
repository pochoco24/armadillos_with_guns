class_name BipedalState
extends PlayerState


func input_update(event: InputEvent):
	if event.is_action_pressed("ball_mode"):
		change_state("Ball")


func physics_update(delta: float):
	player.cam_pivot.position = player.position

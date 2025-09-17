class_name BallState
extends PlayerState

@export var ball: RigidBody3D


func physics_update(delta: float) -> void:
	super(delta)
	
	var input_dir = Input.get_vector("left", "right", "up", "down")
	
	# Rotate with camera
	var input_dir_world = input_dir.rotated(-player.cam_pivot.rotation.y)
	
	var input_dir_3d = Vector3(input_dir_world.x, 0.0, input_dir_world.y)
	
	ball.apply_torque(Vector3.UP.cross(input_dir_3d) * ball.acceleration)
	
	player.position = ball.position
	player.cam_pivot.position = ball.position

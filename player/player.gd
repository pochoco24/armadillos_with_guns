extends CharacterBody3D

enum States {IDLE, RUN, JUMP, BALL, LEDGE_GRAB}

@export var cam_pivot: Node3D
@export var ball: RigidBody3D
@onready var player_mesh: MeshInstance3D = $PlayerMesh

@export var acceleration: float
@export var ball_acceleration: float
@export var speed: float
@export var jump_speed: float
@export var ball_jump_speed: float
@export var gravity: float
@export var void_y_level: float

var input_dir := Vector2.ZERO
var velocity_flat := Vector2.ZERO

var ball_mode = false

var state: States = States.IDLE


func _ready() -> void:
	# Lock mouse in center of screen
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	# Update ball mode
	ball_mode = true
	set_ball_mode(false)

func _physics_process(delta: float) -> void:
	
	# State machine
	match state:
		States.IDLE:
			print(2)
	
	
	# Kill player if it falls to void
	if position.y < void_y_level:
		position = Vector3.UP
		velocity = Vector3.UP
		ball.position = Vector3.UP
		ball.angular_velocity = Vector3.ZERO
		ball.linear_velocity = Vector3.ZERO
		cam_pivot.move_to_position(position, false)
	
	# up and down are flipped to match 3D Z axis
	input_dir = Input.get_vector("left", "right", "up", "down")
	
	# Rotate with camera
	input_dir = input_dir.rotated(-cam_pivot.rotation.y)
	
	velocity_flat = Vector2(velocity.x, velocity.z)
	
	if ball_mode:
		var input_dir_3d = Vector3(input_dir.x, 0.0, input_dir.y)
		ball.apply_torque(Vector3.UP.cross(input_dir_3d) * ball_acceleration)
		
		if Input.is_action_just_pressed("jump") and ball.on_floor:
			ball.apply_impulse(Vector3.UP * ball_jump_speed)
		
	else:
		velocity_flat = velocity_flat.move_toward(input_dir * speed, acceleration)
		
		velocity.x = velocity_flat.x
		velocity.z = velocity_flat.y
		
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y += jump_speed
		
		velocity.y -= gravity
	
	
	move_and_slide()
	
	if ball_mode:
		position = ball.position
	
	cam_pivot.move_to_position(position)


func set_ball_mode(enabled: bool):
	if enabled == ball_mode:
		return
	
	# Toggle visibility and collisions for player
	player_mesh.visible = not enabled
	set_collision_layer_value(1, not enabled)
	set_collision_mask_value(1, not enabled)
	set_collision_mask_value(2, not enabled)
	disable_mode = CollisionObject3D.DISABLE_MODE_REMOVE
	
	# Toggle visibility and collisions for ball
	ball.visible = enabled
	ball.set_collision_layer_value(1, enabled)
	ball.set_collision_mask_value(1, enabled)
	ball.set_collision_mask_value(2, enabled)
	ball.freeze = not enabled
	
	if not enabled:
		position = ball.position
		velocity = ball.linear_velocity
		
	else:
		ball.position = position
		ball.linear_velocity = velocity
	
	ball_mode = enabled


func _input(event: InputEvent) -> void:
	# Ball mode
	set_ball_mode(Input.is_action_pressed("ball_mode"))
	
	# Game exit
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

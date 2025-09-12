extends CharacterBody3D

enum States {IDLE, RUN, JUMP, FALLING, BALL, LEDGE_GRAB}

@export var cam_pivot: Node3D
@export var ball: RigidBody3D
@onready var player_mesh: MeshInstance3D = $PlayerMesh
@onready var jump_buffer: Timer = $JumpBuffer
@onready var coyote_time: Timer = $CoyoteTime

@export var acceleration: float
@export var ball_acceleration: float
@export var speed: float
@export var jump_speed: float
@export var ball_jump_speed: float
@export var gravity: float
@export var void_y_level: float

var input_dir := Vector2.ZERO
var velocity_flat := Vector2.ZERO
var was_on_floor = false

var state: States = States.IDLE:
	set = set_state


func _ready() -> void:
	# Lock mouse in center of screen
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	set_state(States.BALL)

func _physics_process(delta: float) -> void:
	var queue_coyote_time = false
	
	if is_on_floor() != was_on_floor:
		if not is_on_floor():
			queue_coyote_time = true
		was_on_floor = is_on_floor()
	
	
	# Kill player if it falls to void
	if position.y < void_y_level:
		position = Vector3.UP
		velocity = Vector3.UP
		ball.position = Vector3.UP
		ball.angular_velocity = Vector3.ZERO
		ball.linear_velocity = Vector3.ZERO
		cam_pivot.move_to_position(position, false)
	
	# Rotate with camera
	var input_dir_world = input_dir.rotated(-cam_pivot.rotation.y)
	
	velocity_flat = Vector2(velocity.x, velocity.z)
	
	if state == States.BALL:
		var input_dir_3d = Vector3(input_dir_world.x, 0.0, input_dir_world.y)
		ball.apply_torque(Vector3.UP.cross(input_dir_3d) * ball_acceleration)
		
		if Input.is_action_just_pressed("jump") and ball.on_floor:
			ball.apply_impulse(Vector3.UP * ball_jump_speed)
		
	elif state in [States.IDLE, States.RUN]:
		velocity_flat = velocity_flat.move_toward(input_dir_world * speed, acceleration)
		
		velocity.x = velocity_flat.x
		velocity.z = velocity_flat.y
		
		if Input.is_action_just_pressed("jump"):
			if is_on_floor() or not coyote_time.is_stopped():
				velocity.y += jump_speed
				queue_coyote_time = false
			else:
				jump_buffer.start()
		
		elif is_on_floor() and not jump_buffer.is_stopped():
			velocity.y += jump_speed
			queue_coyote_time = false
			jump_buffer.stop()
		
		velocity.y -= gravity
	
	move_and_slide()
	
	if state == States.BALL:
		position = ball.position
	
	cam_pivot.move_to_position(position)


func set_state(new_state: States):
	if new_state == state:
		return
	
	# Entering ball
	if new_state == States.BALL:
		player_mesh.visible = false
		set_collision_layer_value(1, false)
		set_collision_mask_value(1, false)
		set_collision_mask_value(2, false)
		
		ball.visible = true
		ball.set_collision_layer_value(1, true)
		ball.set_collision_mask_value(1, true)
		ball.set_collision_mask_value(2, true)
		ball.freeze = false
		
		ball.position = position
		ball.linear_velocity = velocity
	
	# Exiting ball
	if state == States.BALL:
		player_mesh.visible = true
		set_collision_layer_value(1, true)
		set_collision_mask_value(1, true)
		set_collision_mask_value(2, true)
		
		ball.visible = false
		ball.set_collision_layer_value(1, false)
		ball.set_collision_mask_value(1, false)
		ball.set_collision_mask_value(2, false)
		ball.freeze = true
		
		position = ball.position
		velocity = ball.linear_velocity
	
	state = new_state


func _input(event: InputEvent) -> void:
	# up and down are flipped to match 3D Z axis
	input_dir = Input.get_vector("left", "right", "up", "down")
	
	if state == States.BALL and event.is_action_released("ball_mode"):
		if input_dir == Vector2.ZERO:
			set_state(States.IDLE)
		else:
			set_state(States.IDLE)
		
	elif state == States.IDLE and input_dir != Vector2.ZERO:
		set_state(States.RUN)
		
	elif state in [States.IDLE, States.RUN] and event.is_action_pressed("ball_mode"):
		set_state(States.BALL)
	
	# Game exit
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

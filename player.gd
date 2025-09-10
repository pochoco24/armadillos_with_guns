extends CharacterBody3D

@export var cam_pivot: Node3D
@export var ball: RigidBody3D
@onready var player_mesh: MeshInstance3D = $PlayerMesh
@onready var remote_transform_3d: RemoteTransform3D = $RemoteTransform3D

@export var cam_sensitivity: float
@export var acceleration: float
@export var ball_acceleration: float
@export var speed: float
@export var ball_speed: float
@export var jump_speed: float
@export var ball_jump_speed: float
@export var gravity: float

var input_dir := Vector2.ZERO
var velocity_flat := Vector2.ZERO
var ball_mode = false


func _ready() -> void:
	# Lock mouse in center of screen
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta: float) -> void:
	# up and down are flipped to match 3D Z axis
	input_dir = Input.get_vector("left", "right", "up", "down")
	
	# Rotate with camera
	input_dir = input_dir.rotated(-cam_pivot.rotation.y)
	
	if ball_mode:
		var input_dir_3d = Vector3(input_dir.x, 0.0, input_dir.y)
		ball.apply_torque(Vector3.UP.cross(input_dir_3d) * ball_acceleration)
		
		if Input.is_action_just_pressed("jump"):
			ball.apply_force(Vector3.UP * ball_jump_speed)
		
	else:
		velocity_flat = velocity_flat.move_toward(input_dir * speed, acceleration)
		
		velocity.x = velocity_flat.x
		velocity.z = velocity_flat.y
		
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y += jump_speed
		
		velocity.y -= gravity
	
	
	move_and_slide()


func set_ball_mode(enabled: bool):
	player_mesh.visible = not enabled
	set_collision_layer_value(1, not enabled)
	set_collision_mask_value(1, not enabled)
	
	if enabled:
		position = ball.position
		
	else:
		ball.position = position


func _input(event: InputEvent) -> void:
	# Camera rotation
	if event is InputEventMouseMotion:
		cam_pivot.rotation_degrees.x -= event.relative.y * cam_sensitivity
		cam_pivot.rotation_degrees.x = clamp(cam_pivot.rotation_degrees.x, -90, 90)
		cam_pivot.rotation_degrees.y -= event.relative.x * cam_sensitivity
	
	# Ball mode
	ball_mode = Input.is_action_pressed("ball_mode")
	
	# Game exit
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

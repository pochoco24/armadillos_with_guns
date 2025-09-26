extends CharacterBody3D

@export var cam_pivot: Node3D
@export var ball: RigidBody3D
@export var mesh: Node3D
@export var anim: AnimationPlayer
@export var jump_buffer: Timer
@export var coyote_time: Timer
@export var shotgun_cooldown: Timer

@export var gravity: float = 0.1
@export var acceleration: float = 0.1
@export var speed: float = 0.5
@export var rotation_speed: float = 0.5

@export var shotgun_recoil: float = 10.0
@export var ball_shotgun_recoil: float = 10.0


func _ready() -> void:
	# Lock mouse
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


#func shoot():
	#if not shotgun_cooldown.is_stopped():
		#return
	#
	#var camera_dir: Vector3 = -cam_pivot.basis.z
	#
	#if current_state.name == "Ball":
		#ball.linear_velocity = Vector3.ZERO
		#ball.apply_impulse(camera_dir * -shotgun_recoil)
	#elif current_state is BipedalState:
		#velocity = Vector3.ZERO
		#velocity += camera_dir * -ball_shotgun_recoil
	#
	#shotgun_cooldown.start()


func _input(event: InputEvent) -> void:
	
	# Exit game
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	# Shoot
	#elif event.is_action_pressed("shoot"):
		#shoot()

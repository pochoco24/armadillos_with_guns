extends Node3D

@export var cam_sensitivity: float
@export var cam_follow_speed: float
@export var fov_tween_duration: float
@onready var camera_3d: Camera3D = $SpringArm3D/Camera3D

@onready var default_fov = camera_3d.fov
var tween: Tween


func change_fov(fov: float):
	if tween:
		tween.kill() # Abort the previous animation.
	tween = create_tween()
	
	tween.tween_property(camera_3d, "fov", fov, fov_tween_duration).set_ease(
			Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)


func move_to_position(pos: Vector3, smooth := true):
	if smooth:
		position = position.lerp(pos, cam_follow_speed)
	else:
		position = pos


func _input(event: InputEvent) -> void:
	# Camera rotation
	if event is InputEventMouseMotion:
		rotation_degrees.x -= event.relative.y * cam_sensitivity
		rotation_degrees.x = clamp(rotation_degrees.x, -90, 90)
		rotation_degrees.y -= event.relative.x * cam_sensitivity

extends Node3D

@export var cam_sensitivity: float
@export var cam_follow_speed: float


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

extends BipedalState

var enable_ledge_detection_signal = false

# How far the character will be from the ledge while grabbing it
@export var ledge_grab_distance: float


func enter():
	enable_ledge_detection_signal = true


func exit():
	enable_ledge_detection_signal = false


func input_update(event: InputEvent):
	if event.is_action_pressed("jump"):
		if not player.coyote_time.is_stopped():
			change_state("Jumping")
		else:
			player.jump_buffer.start()
	else:
		super(event)


func physics_update(delta: float):
	super(delta)
	
	if player.is_on_floor():
		if not player.jump_buffer.is_stopped():
			change_state("Jumping")
		elif Input.get_vector("down", "up", "right", "left") != Vector2.ZERO:
			change_state("Run")
		else:
			change_state("Idle")


func _on_ledge_detection_ledge_detected(point: Vector3, normal: Vector3) -> void:
	if enable_ledge_detection_signal:
		player.rotation.y = normal.angle_to(Vector3.FORWARD)
		change_state("LedgeGrab")

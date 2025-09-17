extends PlayerState


func input_update(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		change_state("Jumping")
	else:
		super(event)

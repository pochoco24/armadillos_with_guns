extends StateMachine

@export var player: CharacterBody3D


func _ready() -> void:
	for child in get_children():
		if child is PlayerState:
			child.player = player
	
	super()

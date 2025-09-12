extends CharacterBody3D

@export var states_node: Node
@export var current_state: PlayerState

@export var cam_pivot: Node3D
@export var ball: RigidBody3D
@export var mesh: MeshInstance3D
@export var jump_buffer: Timer
@export var coyote_time: Timer

@export var gravity: float = 0.1
@export var acceleration: float = 0.1
@export var speed: float = 0.5

var states: Dictionary[String, PlayerState]


func _ready() -> void:
	# Get states
	for child in states_node.get_children():
		if child is PlayerState:
			states[child.name] = child
			child.transitioned.connect(_on_state_transitioned)
			child.player = self
	
	# Lock mouse
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _on_state_transitioned(new_state_name: String):
	print(new_state_name)
	var new_state = states[new_state_name]
	
	if current_state == new_state:
		return
	
	if current_state:
		current_state.exit()
	
	new_state.enter()
	
	current_state = new_state


func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)


func _input(event: InputEvent) -> void:
	if current_state:
		current_state.input_update(event)
	
	# Exit game
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

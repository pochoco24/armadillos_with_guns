class_name StateMachine
extends Node

@export var initial_state: State

var states: Dictionary[String, State]
var current_state: State


func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.transitioned.connect(_on_state_transitioned)
	
	if initial_state:
		initial_state.enter()
		current_state = initial_state


func _on_state_transitioned(new_state_name: String):
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

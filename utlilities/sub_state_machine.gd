class_name SubStateMachine
extends State
## A StateMachine that can be nested within a StateMachine. It extends the
## State class so it can be put as a child of a state machine.
## Calling change_state() changes the state of the parent StateMachine.
## Calling set_substate() changes the substate of THIS SubStateMachine.

var substates: Dictionary[String, State]
@export var current_substate: State


func _ready() -> void:
	for child in get_children():
		if child is State:
			substates[child.name] = child
			child.transitioned.connect(_on_substate_transitioned)


func set_substate(new_substate_name: String):
	_on_substate_transitioned(new_substate_name)


func change_state(new_state_name: String):
	# Exit current substate and then change state of parent StateMachine
	current_substate.exit()
	current_substate = null
	super(new_state_name)


func _on_substate_transitioned(new_substate_name: String):
	var new_substate = substates[new_substate_name]
	
	if current_substate == new_substate:
		return
	
	if current_substate:
		current_substate.exit()
	
	new_substate.enter()
	
	current_substate = new_substate


func physics_update(delta: float) -> void:
	if current_substate:
		current_substate.physics_update(delta)


func input_update(event: InputEvent) -> void:
	if current_substate:
		current_substate.input_update(event)

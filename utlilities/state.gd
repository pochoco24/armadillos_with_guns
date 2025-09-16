class_name State
extends Node

signal transitioned(new_state_name: String)


func change_state(new_state_name: String):
	transitioned.emit(new_state_name)


func enter():
	return


func exit():
	return


func physics_update(delta: float) -> void:
	return


func input_update(event: InputEvent) -> void:
	return

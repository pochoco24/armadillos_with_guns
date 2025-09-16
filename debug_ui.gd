extends Control

@onready var label: Label = $Label


func _process(delta: float) -> void:
	label.text = ""
	label.text += "JumpBuffer: %s \n" % $"../Player/JumpBuffer".time_left
	label.text += "CoyoteTime: %s" % $"../Player/CoyoteTime".time_left

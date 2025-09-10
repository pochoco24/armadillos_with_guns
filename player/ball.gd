extends RigidBody3D

@export var max_floor_dot : float

var on_floor := false


func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	on_floor = false
	
	for i in get_contact_count():
		var normal = state.get_contact_local_normal(i)
		if Vector3.UP.dot(normal) > max_floor_dot:
			on_floor = true

extends RigidBody3D
## Players rigid body ball
##
## Includes custom logic to only bounce when hitting walls and ceilings but not
## floor. Since bouncing on floor can feel hard to control and jump but
## bouncing on walls are useful to quickly change direction and do fun stuff.

@export var max_floor_dot: float
@export var acceleration: float
@export_range(0.0, 1.0) var wall_bounce: float 

var on_floor := false
var prev_linear_velocity: Vector3
var prev_angular_velocity: Vector3
var speeds_buffer := []
var speeds_buffer_limit: int = 3


func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	on_floor = false
	
	speeds_buffer.append(state.linear_velocity.length())
	if speeds_buffer.size() > speeds_buffer_limit:
		speeds_buffer.remove_at(0)
	
	for i in get_contact_count():
		var normal = state.get_contact_local_normal(i)
		
		if Vector3.UP.dot(normal) > max_floor_dot: # Collided with floor
			on_floor = true
			
		else: # Collided with wall or ceiling
			var prev_velocity_dir = prev_linear_velocity.normalized()
			if prev_velocity_dir.dot(normal) < 0.0:
				# Ensure to bounce at full velocity of impact
				prev_velocity_dir *= speeds_buffer.max()
				state.linear_velocity = prev_velocity_dir.bounce(normal) * wall_bounce
				state.angular_velocity = prev_angular_velocity
	
	prev_linear_velocity = state.linear_velocity
	prev_angular_velocity = state.angular_velocity

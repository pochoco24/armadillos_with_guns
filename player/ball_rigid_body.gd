extends RigidBody3D
## Players rigid body ball
##
## Includes custom logic to only bounce when hitting walls and ceilings but not
## floor. Since bouncing on floor can feel hard to control and jump but
## bouncing on walls are useful to quickly change direction and do fun stuff.

@export var max_floor_dot: float
@export var acceleration: float
@export_range(0.0, 1.0) var wall_bounce: float 
@export var velocity_cast: ShapeCast3D

var on_floor := false


func _physics_process(delta: float) -> void:
	# Use a shape cast to detect wall collision BEFORE the collision happens
	# so BOUNCE gets set right on time
	
	velocity_cast.target_position = linear_velocity * delta
	velocity_cast.position = position
	velocity_cast.force_update_transform()
	velocity_cast.force_shapecast_update()
	
	if velocity_cast.is_colliding():
		if Vector3.UP.dot(velocity_cast.get_collision_normal(0)) < max_floor_dot:
			physics_material_override.bounce = wall_bounce
		else:
			physics_material_override.bounce = 0.0


func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	on_floor = false
	
	for i in get_contact_count():
		var normal = state.get_contact_local_normal(i)
		
		if Vector3.UP.dot(normal) > max_floor_dot: # Collided with floor
			on_floor = true

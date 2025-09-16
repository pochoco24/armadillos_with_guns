extends RayCast3D
## Spins a RayCast3D to make it behave like a RayCast ring. Used for detecting
## the closest collision in a circle.

signal collided(point: Vector3, normal: Vector3, angle: float)

## Number of angles the raycast detects on.
@export var resolution: int = 0


func _physics_process(delta: float) -> void:
	var has_hit = false
	var closest_hit = Vector3.ZERO
	var hit_normal = Vector3.ZERO
	var angle = 0.0
	
	for i in resolution:
		rotation_degrees.y = 360.0 * (float(i) / resolution)
		force_raycast_update()
		
		if not is_colliding():
			continue
		
		if has_hit:
			# Check which raycast hit closer
			if (
					closest_hit.distance_squared_to(global_position)
					< get_collision_point().distance_squared_to(global_position)
			):
				closest_hit = get_collision_point()
		else:
			has_hit = true
			closest_hit = get_collision_point()
			hit_normal = get_collision_normal()
			angle = rotation_degrees.y
	
	if has_hit:
		collided.emit(closest_hit, hit_normal, angle)

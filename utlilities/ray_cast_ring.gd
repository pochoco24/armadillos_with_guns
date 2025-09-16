extends Node3D

signal ring_collided(collision_point: Vector3)

var raycasts: Array[RayCast3D]

@export_group("Ring Properties")
@export var raycast_count: int = 0


func create_ring():
	for child in get_children():
		child.queue_free()
	
	for i in raycast_count:
		var raycast = RayCast3D.new()
		raycast.target_position = Vector3.RIGHT
		add_child(raycast, true)
		raycast.owner = self
		raycast.rotation_degrees.y = 360.0 * (float(i) / raycast_count)


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	for child in get_children():
		if child is RayCast3D:
			raycasts.append(child)


func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	var has_hit = false
	var closest_hit = Vector3.ZERO
	
	for raycast in raycasts:
		if not raycast.is_colliding():
			continue
		
		if has_hit:
			# Check which raycast hit closer
			if (
					closest_hit.distance_squared_to(global_position)
					< raycast.get_collision_point().distance_squared_to(global_position)
			):
				closest_hit = raycast.get_collision_point()
		else:
			has_hit = true
			closest_hit = raycast.get_collision_point()
	
	if has_hit:
		ring_collided.emit(closest_hit)

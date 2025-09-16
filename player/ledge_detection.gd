extends Node3D

signal ledge_detected(point: Vector3, normal: Vector3)

@onready var floor_ray_pivot: Node3D = $FloorRayPivot
@onready var floor_ray_cast: RayCast3D = $FloorRayPivot/FloorRayCast


func _on_spinning_ray_cast_3d_collided(point: Vector3, normal: Vector3, angle: float) -> void:
	floor_ray_pivot.rotation_degrees.y = angle
	floor_ray_cast.force_raycast_update()
	
	if floor_ray_cast.is_colliding():
		var ledge_point = point
		ledge_point.y = floor_ray_cast.get_collision_point().y
		
		ledge_detected.emit(ledge_point, normal)
		print(ledge_point)
	

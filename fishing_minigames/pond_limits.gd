extends Area3D
class_name FishSpawner


@onready var collision_shape: CollisionShape3D = %CollisionShape3D


var spawned_fish: Array[Fish]


func spawn_fish(fish_array: Array[PackedScene]) -> void:
	for fish in fish_array:
		var instance := fish.instantiate()
		add_child(instance)
		instance.global_position = _pick_random_spawn_point()
		instance.activate_fish(instance.global_position, collision_shape)
		spawned_fish.append(instance)


func _pick_random_spawn_point() -> Vector3:
	var angle: float = randf() * TAU
	var dist_from_center: float = sqrt(randf()) * (collision_shape.shape.radius)

	var pos: Vector3 = Vector3(
		cos(angle) * dist_from_center,
		-1.5,
		sin(angle) * dist_from_center
	)

	return global_position + pos


func remove_all_fish() -> void:
	for fish in spawned_fish:
		if fish:
			fish.queue_free()
	spawned_fish.clear()

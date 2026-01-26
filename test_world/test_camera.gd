extends Camera3D
class_name TestCamera


var start_pos: Vector3 = Vector3.ZERO
var start_rot: Vector3 = Vector3.ZERO

var max_position_offset = 0.05
var max_rotation_offset = 0.05

var impact: float = 0.0
var impact_decay: float = 10

var shake: float = 0.0


func _ready() -> void:
	start_pos = position
	start_rot = rotation


func _on_add_camera_shake(amount: float) -> void:
	impact = impact + amount


func _process(delta: float) -> void:
	impact = maxf(impact - impact_decay * delta, 0.0)
	shake = impact * impact

	position = start_pos + Vector3(
		randf_range(-1.0, 1.0) * max_position_offset * shake,
		randf_range(-1.0, 1.0) * max_position_offset * shake,
		randf_range(-1.0, 1.0) * max_position_offset * shake,
	)

	rotation = start_rot + Vector3(
		randf_range(-1.0, 1.0) * max_rotation_offset * shake,
		randf_range(-1.0, 1.0) * max_rotation_offset * shake,
		0.0
	)

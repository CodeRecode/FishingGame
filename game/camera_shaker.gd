extends Node3D


var max_translation_offset = 0.05
var max_rotation_offset = 0.05

var impact: float = 0.0
var impact_decay: float = 10

var shake: float = 0.0

var base_transform: Transform3D

func _on_fishing_system_add_camera_shake(amount: float) -> void:
	impact = impact + amount

func _ready() -> void:
	base_transform = transform

func _process(delta: float) -> void:
	# warn: floating point precision could break here
	if impact > 0.0:
		impact = maxf(impact - impact_decay * delta, 0.0)
		shake = pow(impact, 2)
		_apply_shake()
	else:
		transform = base_transform

func _apply_shake() -> void:
	var translation = Vector3(
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0),
	) * max_translation_offset * shake

	var rotation = Vector3(
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0),
		0.0
	) * max_rotation_offset * shake
	
	transform = base_transform
	transform.origin += translation
	rotate_x(rotation.x)
	rotate_y(rotation.y)
	#rotate_z(rotation.z)

class_name IdleManager
extends BaseManager

@export var idle_ui: Control
@export var camera: Camera3D
@export var camera_pos: Node3D
@export var camera_look_target: Node3D
@export var cam_speed: float = 5.0

func _init() -> void:
	_state_to_activate = Game.State.IDLE


func _on_activate() -> void:
	idle_ui.visible = true


func _on_deactivate() -> void:
	idle_ui.visible = false
	
func _process(delta: float) -> void:
	if !camera:
		return

	# slide to settle in camera pos
	if camera_pos:
		camera.global_position = camera.global_position.lerp(
			camera_pos.global_position,
			cam_speed * delta
		)
	
	if camera_look_target:
		camera.look_at(camera_look_target.global_position, Vector3.UP)

class_name IntroManager
extends BaseManager

@export var camera: Camera3D
@export var camera_look_target: Node3D
@export var camera_follow_path: PathFollow3D

@export var duration := 6.0 # seconds

var _current_progress := 0.0

func _init() -> void:
	_state_to_activate = Game.State.INTRO
	
func _on_activate() -> void:
	if not camera_follow_path or not camera:
		printerr("IntroManager: Missing camera_follow_path / camera")
		return
	
	_current_progress = 0.0;
	camera_follow_path.progress_ratio = 0.0

func _process(delta: float) -> void:
	if _is_active:
		_update_intro(delta)

func _update_intro(delta: float) -> void:
	var next_progress = _current_progress + delta / max(duration, 0.001);
	_current_progress = clamp(next_progress, 0.0, 1.0)
	
	camera_follow_path.progress_ratio = _current_progress
	
	if camera and camera_look_target:
		camera.global_transform = camera_follow_path.global_transform
		camera.look_at(camera_look_target.global_position, Vector3.UP)
		
	if _current_progress >= 1.0:
		game.current_state = Game.State.IDLE
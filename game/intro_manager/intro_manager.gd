class_name IntroManager
extends Node

@export var game: Game

@export var camera: Camera3D
@export var camera_look_target: Node3D
@export var camera_follow_path: PathFollow3D

@export var duration := 6.0 # seconds

var _is_ready := false
var _is_active := false

var _current_progress := 0.0

func _is_intro_state(state: Game.State) -> bool:
	return state == Game.State.INTRO


func _ready() -> void:
	if not game:
		printerr("IntroManager: No game connected. Will never start.")
		return
	game.state_enter.connect(_game_state_enter)
	game.state_exit.connect(_game_state_exit)
	
	_is_ready = true
	
	if _is_intro_state(game.current_state):
		_start()


func _start() -> void:
	if not camera_follow_path or not camera:
		printerr("IntroManager: Missing camera_follow_path / camera")
		return
	
	_current_progress = 0.0;
	camera_follow_path.progress_ratio = 0.0
	
	_is_active = true


func _stop() -> void:
	_is_active = false


func _game_state_enter(state: Game.State):
	if _is_intro_state(state):
		_start()


func _game_state_exit(state: Game.State):
	if _is_intro_state(state):
		_stop()


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
		_stop()
		game.current_state = Game.State.IDLE

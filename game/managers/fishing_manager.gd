class_name FishingManager
extends BaseManager

@export var camera: Camera3D
@export var camera_pos: Node3D
@export var camera_look_target: Node3D
@export var cam_speed: float = 5.0

@onready var failure_chord_player: AudioStreamPlayer = %FailureChordPlayer

signal set_fishing_game_active(value: bool)

var debug_force_success: bool = true
var _look_at_target: CharacterBody3D = null

func _init() -> void:
	_state_to_activate = Game.State.FISHING

func _on_activate() -> void:
	set_fishing_game_active.emit(true)

func _on_fishing_system_state_changed(new_state: State) -> void:
	if new_state is FailureState:
		game.fail_catch()
		failure_chord_player.play()
		set_fishing_game_active.emit(false)
	elif new_state is SuccessState:
		game.succeed_catch(new_state.fish_caught.fish_data)
		set_fishing_game_active.emit(false)


func _on_look_at_bobber(bobber: CharacterBody3D) -> void:
	_look_at_target = bobber


func _on_look_at_casting_indicator(casting_indicator: CharacterBody3D) -> void:
	_look_at_target = casting_indicator


func _process(delta: float) -> void:
	if !camera:
		return

	# slide to settle in camera pos
	if camera_pos:
		camera.global_position = camera.global_position.lerp(
			camera_pos.global_position,
			cam_speed * delta
		)

	if camera_look_target and _look_at_target == null:
		camera.look_at(camera_look_target.global_position, Vector3.UP)
	elif camera_look_target and _look_at_target:
		var target := camera.global_transform.looking_at((camera_look_target.global_position + _look_at_target.global_position) / 2, Vector3.UP)
		camera.global_transform = camera.global_transform.interpolate_with(
			target,
			cam_speed * delta
		)

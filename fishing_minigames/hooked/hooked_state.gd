extends State
class_name HookedState


signal add_camera_shake(impact: float)


@export var landing_state: State
@export var failure_state: State


@onready var countdown_prompt: CountdownPrompt = %CountdownPrompt


var camera: Camera3D = null

var hooked_fish: TestFish = null
var current_input_index: int = 0
var timer: float = 0.0


func _ready() -> void:
	camera = get_viewport().get_camera_3d()


func enter(_previous_state: State) -> void:
	add_camera_shake.emit(1.4)

	if _previous_state is ReelingState:
		hooked_fish = _previous_state.detected_fish

	current_input_index = 0
	timer = 0.0

	countdown_prompt.configure_prompt(0.0, hooked_fish.fish_data.input_window_seconds)
	countdown_prompt.set_visibility(true)


func exit() -> void:
	countdown_prompt.set_visibility(false)


func frame_update(_delta: float) -> State:
	var prompt: String = ""

	if current_input_index < hooked_fish.fish_data.hooking_sequence.size():
		prompt = hooked_fish.fish_data.Inputs.find_key(hooked_fish.fish_data.hooking_sequence[current_input_index])

	countdown_prompt.update_visual(camera, hooked_fish.global_position, prompt)
	return null


func physics_update(delta: float) -> State:
	var starting_index: int = current_input_index
	timer += delta

	countdown_prompt.value = clampf(timer, 0.0, hooked_fish.fish_data.input_window_seconds)

	if timer > hooked_fish.fish_data.input_window_seconds or Input.is_action_just_pressed("cancel"):
		return failure_state

	if current_input_index < hooked_fish.fish_data.hooking_sequence.size():
		current_input_index = hooked_fish.check_player_input(current_input_index, hooked_fish.fish_data.hooking_sequence)

		if starting_index < current_input_index:
			timer = 0.0
			add_camera_shake.emit(0.7)

	elif current_input_index >= hooked_fish.fish_data.hooking_sequence.size():
		return landing_state

	return null

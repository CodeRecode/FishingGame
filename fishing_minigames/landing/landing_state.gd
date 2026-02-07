extends State
class_name LandingState


signal add_camera_shake(impact: float)


@export var success_state: SuccessState
@export var failure_state: State


@onready var countdown_prompt: CountdownPrompt = %CountdownPrompt
@onready var bobber: CharacterBody3D = %BobberTest


var camera: Camera3D

var hooked_fish: TestFish = null
var current_input_index: int = 0
var timer: float = 0.0


func _ready() -> void:
	camera = get_viewport().get_camera_3d()


func enter(_previous_state: State) -> void:
	add_camera_shake.emit(1.3)

	if _previous_state is HookedState:
		hooked_fish = _previous_state.hooked_fish

	current_input_index = 0
	timer = 0.0

	countdown_prompt.configure_prompt(0.0, hooked_fish.fish_data.input_window_seconds)
	countdown_prompt.set_visibility(true)


func exit() -> void:
	countdown_prompt.set_visibility(false)
	bobber.visible = false
	bobber.global_position = Vector3(0,0,-11)


func frame_update(_delta: float) -> State:
	var prompt: String = ""

	if current_input_index < hooked_fish.fish_data.landing_sequence.size():
		prompt = hooked_fish.fish_data.Inputs.find_key(hooked_fish.fish_data.landing_sequence[current_input_index])

	countdown_prompt.update_visual(camera, hooked_fish.global_position, prompt)
	return null


func physics_update(delta: float) -> State:
	var starting_index: int = current_input_index
	timer += delta

	countdown_prompt.value = clampf(timer, 0.0, hooked_fish.fish_data.input_window_seconds)

	if timer > hooked_fish.fish_data.input_window_seconds or Input.is_action_just_pressed("cancel"):
		return failure_state

	if current_input_index < hooked_fish.fish_data.hooking_sequence.size():
		current_input_index = hooked_fish.check_player_input(current_input_index, hooked_fish.fish_data.landing_sequence)

		if starting_index < current_input_index:
			timer = 0.0
			add_camera_shake.emit(0.7)

	if current_input_index >= hooked_fish.fish_data.hooking_sequence.size():
		success_state.fish_caught = hooked_fish
		return success_state

	return null

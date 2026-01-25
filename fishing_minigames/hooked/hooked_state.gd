extends State
class_name HookedState


@export var landing_state: State
@export var failure_state: State


var hooked_fish: TestFish = null
var current_input_index: int = 0


func enter(_previous_state: State) -> void:
	print("hooked state")
	current_input_index = 0

	if _previous_state is ReelingState:
		hooked_fish = _previous_state.detected_fish


func physics_update(_delta: float) -> State:
	if current_input_index < hooked_fish.fish_data.hooking_sequence.size():
		current_input_index = hooked_fish.check_player_input(current_input_index, hooked_fish.fish_data.hooking_sequence)
	elif current_input_index >= hooked_fish.fish_data.hooking_sequence.size():
		return landing_state

	if Input.is_action_just_pressed("cancel"):
		return failure_state

	return null

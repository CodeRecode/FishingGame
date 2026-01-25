extends State
class_name HookedState


@export var landing_state: State
@export var failure_state: State


var hooked_fish: CharacterBody3D = null


func enter(_previous_state: State) -> void:
	print("hooked state")

	if _previous_state == ReelingState:
		hooked_fish = _previous_state.detected_fish


func physics_update(_delta: float) -> State:
	if Input.is_action_just_pressed("right"):
		return landing_state
	elif Input.is_action_just_pressed("left"):
		return failure_state

	return null

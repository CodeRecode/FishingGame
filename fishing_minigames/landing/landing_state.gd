extends State
class_name LandingState


@export var success_state: State
@export var failure_state: State


func enter(_previous_state: State) -> void:
	print("landing state")


func physics_update(_delta: float) -> State:
	if Input.is_action_just_pressed("bottom_action"):
		return success_state
	elif Input.is_action_just_pressed("cancel"):
		return failure_state

	return null

extends State
class_name LandingState


@export var success_state: State
@export var failure_state: State


func enter(_previous_state: State) -> void:
	print("landing state")


func physics_update(_delta: float) -> State:
	if Input.is_action_just_pressed("right"):
		return success_state
	elif Input.is_action_just_pressed("left"):
		return failure_state

	return null

extends State
class_name FailureState


@export var casting_state: State


func enter(_previous_state: State) -> void:
	print("failure state")


func physics_update(_delta: float) -> State:
	if Input.is_action_just_pressed("right"):
		return casting_state

	return null

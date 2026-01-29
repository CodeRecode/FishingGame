extends State
class_name FailureState


@export var casting_state: State


func physics_update(_delta: float) -> State:
	#if Input.is_action_just_pressed("bottom_action"):
		#return casting_state

	return null

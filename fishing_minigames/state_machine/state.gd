extends Node
class_name State


var previous_state : State


func enter(_previous_state: State) -> void:
	previous_state = _previous_state
	pass

func exit() -> void:
	pass


func input_update(_event: InputEvent) -> State:
	return null


func frame_update(_delta: float) -> State:
	return null


func physics_update(_delta: float) -> State:
	return null

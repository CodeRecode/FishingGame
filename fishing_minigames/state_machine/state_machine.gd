extends Node
class_name StateMachine


signal current_state_changed(new_state: State)


@export var initial_state : State


var _current_state : State
var _previous_state : State


func initialize():
	if initial_state:
		change_state(initial_state)


func change_state(new_state: State) -> void:
	if _current_state:
		_current_state.exit()

	_previous_state = _current_state
	_current_state = new_state
	_current_state.enter(_previous_state)

	current_state_changed.emit(_current_state)
	#if _previous_state and _current_state:
		#print("Previous State: " + _previous_state.name + ", New State:" + _current_state.name)


func frame_update(delta: float) -> void:
	var new_state: State = _current_state.frame_update(delta)
	if new_state:
		change_state(new_state)


func physics_update(delta: float) -> void:
	var new_state: State = _current_state.physics_update(delta)
	if new_state:
		change_state(new_state)

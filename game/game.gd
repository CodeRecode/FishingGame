class_name Game
extends Node3D

enum State {
	UNKNOWN,
	INTRO,
	IDLE,
	FISHING,
	REWARD,
}

signal state_enter(state: Game.State)
signal state_exit(state: Game.State)

var _current_state: Game.State = Game.State.UNKNOWN

var current_state: Game.State:
	get:
		return _current_state;
	set(state):
		state_exit.emit(_current_state)
		_current_state = state;
		state_enter.emit(_current_state)

func _ready() -> void:
	current_state = Game.State.INTRO

func set_prev_state() -> void:
	var state_count := Game.State.size()
	current_state = (int(current_state) - 1 + state_count) % state_count
	
func set_next_state() -> void:
	var state_count := Game.State.size()
	current_state = (int(current_state) + 1) % state_count

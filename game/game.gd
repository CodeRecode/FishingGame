class_name Game
extends Node3D

enum State {
	UNKNOWN,
	INTRO,
	IDLE,
	FISHING,
	REWARD,
	FAIL,
}

signal state_enter(state: Game.State)
signal state_exit(state: Game.State)

signal on_catch(catch:FishResource)

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


func catch(fish:FishResource) -> void:
	on_catch.emit(fish)

func go_to_idle() -> void:
	current_state = Game.State.IDLE

func go_to_fishing() -> void:
	current_state = Game.State.FISHING

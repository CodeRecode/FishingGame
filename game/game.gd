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
signal on_succeed_catch(catch:FishResource)
signal on_fail_catch()


var _current_state: Game.State = Game.State.UNKNOWN
var _next_state: Game.State = Game.State.UNKNOWN

var current_state: Game.State:
	get:
		return _current_state;
	set(state):
		_next_state = state


func _ready() -> void:
	current_state = Game.State.INTRO


func _process(_delta: float) -> void:
	if _current_state == _next_state:
		return
	
	Input.flush_buffered_events() # flush any inputs on stack
	state_exit.emit(_current_state)
	_current_state = _next_state;
	state_enter.emit(_current_state)

func succeed_catch(fish:FishResource) -> void:
	current_state = Game.State.REWARD
	on_succeed_catch.emit(fish)


func fail_catch() -> void:
	current_state = Game.State.REWARD
	on_fail_catch.emit()


func go_to_idle() -> void:
	current_state = Game.State.IDLE


func go_to_fishing() -> void:
	current_state = Game.State.FISHING

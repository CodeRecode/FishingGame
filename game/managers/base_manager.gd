@abstract
class_name BaseManager
extends Node

@export var game: Game

var _state_to_activate: Game.State

var _is_active := false

func _is_state_to_activate(state: Game.State) -> bool:
	return state == _state_to_activate


func _on_ready() -> void:
	pass # Override with function body.


func _on_activate() -> void:
	pass # Override with function body.


func _on_deactivate() -> void:
	pass # Override with function body.


func _ready() -> void:
	set_process(false)
	if not game:
		printerr("%s: No game connected. Will never activate.", get_class())
		return
	game.state_enter.connect(_game_state_enter)
	game.state_exit.connect(_game_state_exit)

	_on_ready()

	if _is_state_to_activate(game.current_state):
		_on_activate()


func _game_state_enter(state: Game.State):
	if _is_state_to_activate(state):
		Input.flush_buffered_events()
		_is_active = true
		set_process(true)
		_on_activate()


func _game_state_exit(state: Game.State):
	if _is_state_to_activate(state):
		_on_deactivate()
		set_process(false)
		_is_active = false

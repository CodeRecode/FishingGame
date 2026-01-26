extends Label

@export var game: Game
@export var label: Label


func _ready() -> void:
	if not game:
		return
	game.state_enter.connect(_game_state_enter)


func _game_state_enter(state: Game.State):
	label.text = "Current State: %s" % Game.State.keys()[int(game.current_state)]

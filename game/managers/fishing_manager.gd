class_name FishingManager
extends BaseManager

signal set_fishing_game_active(value: bool)

var debug_force_success: bool = true

func _init() -> void:
	_state_to_activate = Game.State.FISHING

# TEMP: Delay then proceed to rewards
func _on_activate() -> void:
	set_fishing_game_active.emit(true)

	#await get_tree().create_timer(1.0).timeout
	#if debug_force_success:
		#succeed_catch()
	#else:
		#fail_catch()
	#debug_force_success = !debug_force_success

func succeed_catch() -> void:
	game.catch(load("res://fish/fish_data/sea_bass.tres")) # TEMP: All fish are sea bass
	game.current_state = Game.State.REWARD

func fail_catch() -> void:
	game.current_state = Game.State.FAIL

func _on_fishing_system_state_changed(new_state: State) -> void:
	if new_state is FailureState:
		set_fishing_game_active.emit(false)
		game.current_state = Game.State.FAIL
	elif new_state is SuccessState:
		game.catch(new_state.fish_caught.fish_data) # TEMP: All fish are sea bass
		set_fishing_game_active.emit(false)
		game.current_state = Game.State.REWARD

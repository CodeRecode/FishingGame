class_name FishingManager
extends BaseManager

var debug_force_success: bool = true

func _init() -> void:
	_state_to_activate = Game.State.FISHING
	
# TEMP: Delay then proceed to rewards
func _on_activate() -> void:
	await get_tree().create_timer(1.0).timeout
	if debug_force_success:
		succeed_catch()
	else:
		fail_catch()
	debug_force_success = !debug_force_success
	
	
func succeed_catch() -> void:
	game.catch(load("res://fish/fish_data/sea_bass.tres")) # TEMP: All fish are sea bass
	game.current_state = Game.State.REWARD
	
func fail_catch() -> void:
	game.current_state = Game.State.FAIL
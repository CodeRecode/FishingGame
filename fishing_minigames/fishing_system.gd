extends Node
class_name FishingSystem


signal state_changed(new_state: State)
signal add_camera_shake(impact: float)
signal look_at_bobber(bobber:CharacterBody3D)
signal look_at_casting_indicator(casting_indicator: CharacterBody3D)


@export var test_fish_array: Array[PackedScene]


@onready var state_machine: StateMachine = %StateMachine
@onready var pond_limits: FishSpawner = %PondLimits


var current_state: State = null
var run_fishing_games: bool = false


func _ready() -> void:
	state_machine.current_state_changed.connect(_on_current_state_changed)


func _on_set_fishing_game_active(value: bool) -> void:
	if value == true:
		state_machine.initialize()
		pond_limits.spawn_fish(test_fish_array)
	elif value == false:
		pond_limits.remove_all_fish()

	run_fishing_games = value


func _on_current_state_changed(new_state: State) -> void:
	current_state = new_state
	state_changed.emit(new_state)


func _on_add_camera_shake(amount: float) -> void:
	add_camera_shake.emit(amount)


func _on_look_at_bobber(bobber: CharacterBody3D) -> void:
	look_at_bobber.emit(bobber)


func _on_look_at_casting_indicator(casting_indicator: CharacterBody3D) -> void:
	look_at_casting_indicator.emit(casting_indicator)


func _process(delta: float) -> void:
	if run_fishing_games:
		state_machine.frame_update(delta)


func _physics_process(delta: float) -> void:
	if run_fishing_games:
		state_machine.physics_update(delta)

extends Node
class_name FishingSystem


signal state_changed(new_state: State)
signal add_camera_shake(impact: float)


@onready var state_machine: StateMachine = %StateMachine


var current_state: State = null


func _ready() -> void:
	state_machine.initialize()
	state_machine.current_state_changed.connect(_on_current_state_changed)


func _on_current_state_changed(new_state: State) -> void:
	current_state = new_state
	state_changed.emit(new_state)


func _on_add_camera_shake(amount: float) -> void:
	add_camera_shake.emit(amount)


func _process(delta: float) -> void:
	state_machine.frame_update(delta)


func _physics_process(delta: float) -> void:
	state_machine.physics_update(delta)

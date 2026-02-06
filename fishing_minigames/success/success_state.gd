extends State
class_name SuccessState


signal look_at_bobber(bobber: CharacterBody3D)


@export var casting_state: State


@onready var controls: ColorRect = %Controls


var fish_caught: TestFish = null


func enter(_previous_state: State) -> void:
	look_at_bobber.emit(null)
	controls.visible = false


func exit() -> void:
	fish_caught = null


func physics_update(_delta: float) -> State:
	return null

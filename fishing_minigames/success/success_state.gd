extends State
class_name SuccessState


@export var casting_state: State


@onready var controls: ColorRect = %Controls


var fish_caught: TestFish = null


func enter(_previous_state: State) -> void:
	controls.visible = false


func exit() -> void:
	fish_caught = null


func physics_update(_delta: float) -> State:
	return null

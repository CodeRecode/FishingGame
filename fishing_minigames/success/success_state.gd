extends State
class_name SuccessState


@export var casting_state: State


var fish_caught: TestFish = null


func exit() -> void:
	fish_caught = null


func physics_update(_delta: float) -> State:
	return null

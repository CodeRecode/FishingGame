extends State
class_name FailureState


signal look_at_bobber(bobber: CharacterBody3D)


@export var casting_state: State

@onready var controls: ColorRect = %Controls


func enter(_previous_state: State) -> void:
	controls.visible = false
	look_at_bobber.emit(null)

func physics_update(_delta: float) -> State:
	#if Input.is_action_just_pressed("bottom_action"):
		#return casting_state

	return null

@tool
extends Resource
class_name FishResource

@export var id: int = 0
@export var display_name: String = ""

enum Inputs {
	UP,
	DOWN,
	LEFT,
	RIGHT,
	BOTTOM_ACTION,
}


@export var hooking_sequence: Array[Inputs]
@export var landing_sequence: Array[Inputs]

@export var input_window_seconds: float
@export var nibbles_before_flee: int

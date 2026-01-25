extends Resource
class_name FishResource


enum Inputs {
	UP,
	DOWN,
	LEFT,
	RIGHT,
	BOTTOM_ACTION,
	RIGHT_ACTION,
	LEFT_ACTION,
	TOP_ACTION,
	RIGHT_TRIGGER,
	RIGHT_BUMPER,
	LEFT_TRIGGER,
	LEFT_BUMPER
}


@export var hooking_sequence: Array[Inputs]
@export var landing_sequence: Array[Inputs]

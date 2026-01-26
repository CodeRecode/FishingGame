extends State
class_name CastingState


const BAR_SLIDE_SPEED: float = 100.0


@export var reeling_state: State


@onready var cast_distance_bar: ProgressBar = %CastDistance
@onready var cast_accuracy_bar: ProgressBar = %CastAccuracy


var bar_direction: int = 1
var cast_dist_active: bool = false
var cast_acc_active: bool = false

var cast_dist: float = 0.0
var cast_acc: float = 0.0


func enter(_previous_state: State) -> void:
	print("casting state")
	cast_distance_bar.visible = true
	cast_accuracy_bar.visible = true

	bar_direction = 1
	cast_dist_active = true
	cast_dist = 0.0
	cast_distance_bar.value = cast_dist
	cast_acc = 0.0
	cast_accuracy_bar.value = cast_acc


func exit() -> void:
	cast_distance_bar.visible = false
	cast_accuracy_bar.visible = false

	cast_dist_active = false
	cast_acc_active = false


func physics_update(delta: float) -> State:
	if cast_dist_active:
		_slide_bar_value(cast_distance_bar, delta)
		_capture_bar_value(cast_distance_bar)
	elif cast_acc_active:
		_slide_bar_value(cast_accuracy_bar, delta)
		_capture_bar_value(cast_accuracy_bar)

	if not cast_dist_active and not cast_acc_active:
		return reeling_state

	return null


func _slide_bar_value(bar: ProgressBar, delta: float) -> void:
	bar.value += bar_direction * BAR_SLIDE_SPEED * delta

	if bar.value >= bar.max_value:
		bar.value = bar.max_value
		bar_direction = -1
	elif bar.value <= bar.min_value:
		bar.value = bar.min_value
		bar_direction = 1


func _capture_bar_value(bar: ProgressBar):
	if Input.is_action_just_pressed("bottom_action"):
		if bar == cast_distance_bar:
			cast_dist = bar.value
			cast_dist_active = false
			cast_acc_active = true
		elif bar == cast_accuracy_bar:
			cast_acc = bar.value
			cast_acc_active = false

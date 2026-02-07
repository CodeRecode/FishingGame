extends State
class_name CastingState


signal look_at_casting_indicator(casting_indicator: CharacterBody3D)


const BAR_SLIDE_SPEED: float = 100.0


@export var reeling_state: ReelingState


@onready var pond_limits: Area3D = %PondLimits
@onready var pond_collider: CollisionShape3D = %CollisionShape3D
@onready var controls: ColorRect = %Controls
@onready var casting_indicator: CastingIndicator = %CastingIndicator
#@onready var cast_distance_bar: ProgressBar = %CastDistance
#@onready var cast_accuracy_bar: ProgressBar = %CastAccuracy


var casting_indicator_start_pos: Vector3 = Vector3.ZERO
var casting_test_time: float = 0.5
var casting_time_elapsed: float = 0.0

#var bar_direction: int = 1
#var cast_dist_active: bool = false
#var cast_acc_active: bool = false
#
#var cast_dist: float = 0.0
#var cast_acc: float = 0.0


func enter(_previous_state: State) -> void:
	controls.visible = true
	casting_indicator.visible = true
	look_at_casting_indicator.emit(casting_indicator)
	#cast_distance_bar.visible = true
	#cast_accuracy_bar.visible = true

	#bar_direction = 1
	#cast_dist_active = true
	#cast_dist = 0.0
	#cast_distance_bar.value = cast_dist
	#cast_acc = 0.0
	#cast_accuracy_bar.value = cast_acc


func exit() -> void:
	casting_indicator.visible = false
	casting_indicator.reset()
	casting_time_elapsed = 0.0
	casting_indicator_start_pos = casting_indicator.global_position
	#cast_distance_bar.visible = false
	#cast_accuracy_bar.visible = false

	#cast_dist_active = false
	#cast_acc_active = false


func physics_update(delta: float) -> State:
	if not casting_indicator.casting_started:
		_move_casting_indicator(delta)

		if Input.is_action_just_pressed("bottom_action"):
			casting_indicator.start_casting_test()
	elif casting_indicator.casting_started:
		casting_time_elapsed += delta

		if casting_time_elapsed > casting_test_time:
			casting_indicator.reset()
			casting_time_elapsed = 0.0
		else:
			casting_indicator.update_casting_visual(casting_time_elapsed / casting_test_time)

			if Input.is_action_just_pressed("bottom_action"):
				reeling_state.bobber_starting_position = random_point_along_radius(casting_indicator.global_position, casting_indicator.accuracy_indicator.inner_radius)
				casting_indicator.global_position = casting_indicator_start_pos
				return reeling_state

	#if cast_dist_active:
		#_slide_bar_value(cast_distance_bar, delta)
		#_capture_bar_value(cast_distance_bar)
	#elif cast_acc_active:
		#_slide_bar_value(cast_accuracy_bar, delta)
		#_capture_bar_value(cast_accuracy_bar)

	#if not cast_dist_active and not cast_acc_active:
		#return reeling_state

	return null


func random_point_along_radius(center: Vector3, radius: float) -> Vector3:
	var angle: float = randf() * TAU

	var x: float = cos(angle) * radius
	var z: float = sin(angle) * radius

	return center + Vector3(x, 0, z)


func _move_casting_indicator(delta: float) -> void:
	var input_x: float = Input.get_axis("left", "right")
	var input_z: float = Input.get_axis("up", "down")

	casting_indicator.velocity = Vector3(input_x, 0.0, input_z) * casting_indicator.speed * delta
	casting_indicator.move_and_slide()
	_keep_casting_indicator_in_pond()


func _keep_casting_indicator_in_pond() -> void:
	var offset: Vector3 = pond_limits.transform.origin - casting_indicator.transform.origin
	offset.y = 0.0

	if offset.length() > pond_collider.shape.radius:
		offset = offset.normalized() * pond_collider.shape.radius * -1
		casting_indicator.global_position = Vector3(
			pond_limits.transform.origin.x + offset.x,
			casting_indicator.global_position.y,
			pond_limits.transform.origin.z + offset.z
		)

#func _slide_bar_value(bar: ProgressBar, delta: float) -> void:
	#bar.value += bar_direction * BAR_SLIDE_SPEED * delta
#
	#if bar.value >= bar.max_value:
		#bar.value = bar.max_value
		#bar_direction = -1
	#elif bar.value <= bar.min_value:
		#bar.value = bar.min_value
		#bar_direction = 1
#
#
#func _capture_bar_value(bar: ProgressBar):
	#if Input.is_action_just_pressed("bottom_action"):
		#if bar == cast_distance_bar:
			#cast_dist = bar.value
			#cast_dist_active = false
			#cast_acc_active = true
		#elif bar == cast_accuracy_bar:
			#cast_acc = bar.value
			#cast_acc_active = false

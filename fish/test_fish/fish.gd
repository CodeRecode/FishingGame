extends CharacterBody3D
class_name Fish


const WAIT_VARIANCE: float = 0.3


@export var fish_data: FishResource


var pond_limits: CollisionShape3D
var spawn_pos: Vector3 = Vector3.ZERO
var target_pos: Vector3 = Vector3.ZERO
var current_pos: Vector3 = Vector3.ZERO
var moving: bool = false
var nibbling: bool = false
var backup_timer: float = 0.0

var wriggling: bool = false
var wriggle_time: float = 0.12
var wriggle_progress: float = 0.0
var wriggle_strength: float = 0.8
var wriggle_frequency: float = 45.0

var reeling: bool = false
var reel_start_pos: Vector3 = Vector3.ZERO
var reel_target_pos: Vector3 = Vector3.ZERO
var reel_step: int = 0
var reel_step_time: float = 0.15
var reel_timer: float = 0.0
var reel_progress: float = 0.0
var reel_step_speed: Vector3 = Vector3.ZERO


func activate_fish(start_pos: Vector3, pond: CollisionShape3D) -> void:
	spawn_pos = start_pos
	pond_limits = pond
	_pick_new_target()
	_wait_to_move()


func _physics_process(delta: float) -> void:
	if wriggling:
		_apply_wriggle(delta)

	if nibbling:
		return

	var dir: Vector3 = target_pos - global_position

	if reeling:
		reel_timer += delta
		reel_progress = reel_timer / reel_step_time

		if reel_progress <= 1:
			global_position = global_position.lerp(target_pos, reel_progress)
		return

	if not moving:
		backup_timer = 0.0
		return

	backup_timer += delta

	if dir.length() < 0.1 or backup_timer > fish_data.wait_time * 2:
		_pick_new_target()
		_wait_to_move()
		return

	velocity = dir.normalized() * fish_data.move_speed * delta
	move_and_slide()
	_keep_fish_in_pond()


func reel_fish_towards_caster(cancel_reeling_pos: Vector3, total_steps: int) -> void:
	reeling = true
	reel_timer = 0.0
	if reel_start_pos == Vector3.ZERO:
		reel_start_pos = global_position
		reel_target_pos = cancel_reeling_pos
		reel_step = 1

	var diff: Vector3 = (reel_target_pos - reel_start_pos) / total_steps
	diff.x = randf_range(diff.x - 10, diff.x + 10)

	target_pos = reel_start_pos + (diff * reel_step)
	if reel_step == total_steps:
		target_pos = cancel_reeling_pos
	reel_step += 1


func start_wriggle() -> void:
	wriggling = true
	current_pos = global_position


func _apply_wriggle(delta: float) -> void:
	wriggle_progress += delta

	var t: float = wriggle_progress * wriggle_frequency
	var offset: Vector3 = Vector3(
		sin(t),
		0,
		cos(t)
	) * wriggle_strength

	global_position = current_pos + offset

	if wriggle_progress > wriggle_time:
		wriggle_progress = 0.0
		wriggling = false
		global_position = current_pos

func _wait_to_move() -> void:
	moving = false
	var time: float = randf_range(fish_data.wait_time - WAIT_VARIANCE, fish_data.wait_time + WAIT_VARIANCE)
	await get_tree().create_timer(time).timeout
	moving = true


func _pick_new_target() -> void:
	var angle := randf() * TAU
	var radius := sqrt(randf()) * fish_data.move_radius

	var offset: Vector3 = Vector3(
		cos(angle) * radius,
		0.0,
		sin(angle) * radius
	)

	target_pos = spawn_pos + offset
	moving = true


func _keep_fish_in_pond() -> void:
	var offset: Vector3 = pond_limits.global_transform.origin - global_transform.origin
	offset.y = 0.0

	if offset.length() > pond_limits.shape.radius:
		offset = offset.normalized() * pond_limits.shape.radius * -1
		global_position = Vector3(
			pond_limits.global_transform.origin.x + offset.x,
			global_position.y,
			pond_limits.global_transform.origin.z + offset.z
		)


func check_player_input(current_input_index: int, input_sequence: Array[FishResource.Inputs]) -> int:
	if current_input_index >= input_sequence.size():
		return current_input_index + 1

	if input_sequence[current_input_index] == fish_data.Inputs.UP:
		if Input.is_action_just_pressed("up"):
			return current_input_index + 1
	if input_sequence[current_input_index] == fish_data.Inputs.DOWN:
		if Input.is_action_just_pressed("down"):
			return current_input_index + 1
	if input_sequence[current_input_index] == fish_data.Inputs.LEFT:
		if Input.is_action_just_pressed("left"):
			return current_input_index + 1
	if input_sequence[current_input_index] == fish_data.Inputs.RIGHT:
		if Input.is_action_just_pressed("right"):
			return current_input_index + 1
	if input_sequence[current_input_index] == fish_data.Inputs.BOTTOM_ACTION:
		if Input.is_action_just_pressed("bottom_action"):
			return current_input_index + 1
	#if input_sequence[current_input_index] == fish_data.Inputs.TOP_ACTION:
		#print("Press Triangle!")
		#if Input.is_action_just_pressed("top_action"):
			#return current_input_index + 1
	#if input_sequence[current_input_index] == fish_data.Inputs.LEFT_ACTION:
		#print("Press Triangle!")
		#if Input.is_action_just_pressed("left_action"):
			#return current_input_index + 1
	#if input_sequence[current_input_index] == fish_data.Inputs.RIGHT_ACTION:
		#print("Press Circle!")
		#if Input.is_action_just_pressed("right_action"):
			#return current_input_index + 1
	#if input_sequence[current_input_index] == fish_data.Inputs.RIGHT_TRIGGER:
		#print("Press R1!")
		#if Input.is_action_just_pressed("right_trigger"):
			#return current_input_index + 1
	#if input_sequence[current_input_index] == fish_data.Inputs.RIGHT_BUMPER:
		#print("Press R2!")
		#if Input.is_action_just_pressed("right_bumper"):
			#return current_input_index + 1
	#if input_sequence[current_input_index] == fish_data.Inputs.LEFT_TRIGGER:
		#print("Press L1!")
		#if Input.is_action_just_pressed("left_trigger"):
			#return current_input_index + 1
	#if input_sequence[current_input_index] == fish_data.Inputs.LEFT_BUMPER:
		#print("Press L2!")
		#if Input.is_action_just_pressed("left_bumper"):
			#return current_input_index + 1

	return current_input_index

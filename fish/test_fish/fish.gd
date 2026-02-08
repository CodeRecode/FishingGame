extends CharacterBody3D
class_name Fish


const WAIT_VARIANCE: float = 0.3


@export var fish_data: FishResource


var pond_limits: CollisionShape3D
var spawn_pos: Vector3 = Vector3.ZERO
var target_pos: Vector3 = Vector3.ZERO
var moving: bool = false
var nibbling_or_hooked: bool = false
var backup_timer: float = 0.0


func activate_fish(start_pos: Vector3, pond: CollisionShape3D) -> void:
	spawn_pos = start_pos
	pond_limits = pond
	_pick_new_target()
	_wait_to_move()


func _physics_process(delta: float) -> void:
	if nibbling_or_hooked:
		return

	if not moving:
		backup_timer = 0.0
		return

	backup_timer += delta
	var dir: Vector3 = target_pos - global_position

	if dir.length() < 0.1 or backup_timer > fish_data.wait_time * 2:
		_pick_new_target()
		_wait_to_move()
		return

	velocity = dir.normalized() * fish_data.move_speed * delta
	move_and_slide()
	_keep_fish_in_pond()


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

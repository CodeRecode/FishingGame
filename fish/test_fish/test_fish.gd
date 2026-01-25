extends CharacterBody3D
class_name TestFish


@export var fish_data: FishResource


func check_player_input(current_input_index: int, input_sequence: Array[FishResource.Inputs]) -> int:
	if input_sequence[current_input_index] == fish_data.Inputs.UP:
		print("Press up!")
		if Input.is_action_just_pressed("up"):
			return current_input_index + 1
	if input_sequence[current_input_index] == fish_data.Inputs.DOWN:
		print("Press down!")
		if Input.is_action_just_pressed("down"):
			return current_input_index + 1
	if input_sequence[current_input_index] == fish_data.Inputs.LEFT:
		print("Press left!")
		if Input.is_action_just_pressed("left"):
			return current_input_index + 1
	if input_sequence[current_input_index] == fish_data.Inputs.RIGHT:
		print("Press right!")
		if Input.is_action_just_pressed("right"):
			return current_input_index + 1
	if input_sequence[current_input_index] == fish_data.Inputs.BOTTOM_ACTION:
		print("Press X (PS Controller)!")
		if Input.is_action_just_pressed("bottom_action"):
			return current_input_index + 1
	if input_sequence[current_input_index] == fish_data.Inputs.TOP_ACTION:
		print("Press Triangle!")
		if Input.is_action_just_pressed("top_action"):
			return current_input_index + 1
	if input_sequence[current_input_index] == fish_data.Inputs.LEFT_ACTION:
		print("Press Triangle!")
		if Input.is_action_just_pressed("left_action"):
			return current_input_index + 1
	if input_sequence[current_input_index] == fish_data.Inputs.RIGHT_ACTION:
		print("Press Circle!")
		if Input.is_action_just_pressed("right_action"):
			return current_input_index + 1
	if input_sequence[current_input_index] == fish_data.Inputs.RIGHT_TRIGGER:
		print("Press R1!")
		if Input.is_action_just_pressed("right_trigger"):
			return current_input_index + 1
	if input_sequence[current_input_index] == fish_data.Inputs.RIGHT_BUMPER:
		print("Press R2!")
		if Input.is_action_just_pressed("right_bumper"):
			return current_input_index + 1
	if input_sequence[current_input_index] == fish_data.Inputs.LEFT_TRIGGER:
		print("Press L1!")
		if Input.is_action_just_pressed("left_trigger"):
			return current_input_index + 1
	if input_sequence[current_input_index] == fish_data.Inputs.LEFT_BUMPER:
		print("Press L2!")
		if Input.is_action_just_pressed("left_bumper"):
			return current_input_index + 1

	return current_input_index

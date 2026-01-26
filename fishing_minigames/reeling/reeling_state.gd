extends State
class_name ReelingState


signal add_camera_shake(impact: float)


@export var casting_state: State
@export var hooked_state: State


@onready var bobber: CharacterBody3D = %BobberTest
@onready var bobber_anim_player: AnimationPlayer = %AnimationPlayer


var bobber_speed: float = 500.0
var detected_fish: TestFish = null
var nibble_count: int = 0
var timer: float = 0.0


func _ready() -> void:
	bobber.visible = false


func _on_fish_detector_body_entered(fish: CharacterBody3D) -> void:
	print("fish detected")
	if fish is TestFish:
		detected_fish = fish


func _on_fish_detector_body_exited(fish: Node3D) -> void:
	print("fish fled")
	if fish is TestFish:
		detected_fish = null


func enter(_previous_state: State) -> void:
	print("reeling state")
	bobber.position = Vector3.ZERO
	detected_fish = null
	timer = 0.0
	nibble_count = 0

	bobber.visible = true


func exit() -> void:
	bobber.visible = false


func physics_update(delta: float) -> State:
	_move_bobber(delta)

	if detected_fish:
		_nibble(delta)

	if detected_fish != null and Input.is_action_just_pressed("bottom_action"):
		return hooked_state
	elif Input.is_action_just_pressed("cancel"):
		return casting_state

	return null


func _move_bobber(delta: float) -> void:
	var input_x: float = Input.get_axis("left", "right")
	var input_z: float = Input.get_axis("up", "down")

	bobber.velocity = Vector3(input_x, 0.0, input_z) * bobber_speed * delta
	bobber.move_and_slide()


func _nibble(delta: float) -> void:
	timer += delta

	if timer >= detected_fish.fish_data.input_window_seconds and nibble_count >= detected_fish.fish_data.nibbles_before_flee:
		detected_fish.queue_free()

	if timer >= detected_fish.fish_data.input_window_seconds and nibble_count < detected_fish.fish_data.nibbles_before_flee:
		nibble_count += 1
		bobber_anim_player.play("bob")
		add_camera_shake.emit(0.8)
		timer = 0.0

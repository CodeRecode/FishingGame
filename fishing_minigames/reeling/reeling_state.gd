extends State
class_name ReelingState


signal add_camera_shake(impact: float)
signal look_at_bobber(bobber: CharacterBody3D)


@export var casting_state: State
@export var hooked_state: State

@onready var pond_limits: Area3D = %PondLimits
@onready var pond_collider: CollisionShape3D = %CollisionShape3D
@onready var bobber: CharacterBody3D = %BobberTest
@onready var bobber_anim_player: AnimationPlayer = %AnimationPlayer

@onready var failure_chord_player_fs: AudioStreamPlayer = %FailureChordPlayerFS
@onready var nibble_player: AudioStreamPlayer = %NibblePlayer


var bobber_speed: float = 1000.0
var bobber_starting_position: Vector3 = Vector3.ZERO
var detected_fish: Fish = null
var nibble_count: int = 0
var timer: float = 0.0
var cancel_reeling: bool = false


func _ready() -> void:
	bobber.visible = false


func _on_fish_detector_body_entered(fish: CharacterBody3D) -> void:
	if fish is Fish:
		detected_fish = fish


func _on_fish_detector_body_exited(fish: Node3D) -> void:
	if fish is Fish:
		detected_fish = null


func enter(_previous_state: State) -> void:
	bobber.global_position = bobber_starting_position
	detected_fish = null
	timer = 0.0
	nibble_count = 0

	bobber.visible = true
	look_at_bobber.emit(bobber)


func exit() -> void:
	bobber.visible = false
	cancel_reeling = false


func physics_update(delta: float) -> State:
	if cancel_reeling:
		return casting_state

	_move_bobber(delta)

	if detected_fish:
		_nibble(delta)
		detected_fish.nibbling_or_hooked = true

	if detected_fish != null and Input.is_action_just_pressed("bottom_action"):
		return hooked_state
	elif Input.is_action_just_pressed("cancel"):
		return casting_state

	return null


func _move_bobber(delta: float) -> void:
	var input_x: float = Input.get_axis("left", "right")
	var input_z: float = Input.get_axis("up", "down")

	input_z = clampf(input_z, 0.0, 1.0)

	bobber.velocity = Vector3(input_x, 0.0, input_z) * bobber_speed * delta
	bobber.move_and_slide()
	_keep_bobber_in_pond()


func _keep_bobber_in_pond() -> void:
	var offset: Vector3 = pond_limits.transform.origin - bobber.transform.origin
	offset.y = 0.0

	if offset.length() > pond_collider.shape.radius:
		offset = offset.normalized() * pond_collider.shape.radius * -1
		bobber.global_position = Vector3(
			pond_limits.transform.origin.x + offset.x,
			bobber.global_position.y,
			pond_limits.transform.origin.z + offset.z
		)


func _nibble(delta: float) -> void:
	timer += delta

	if timer >= detected_fish.fish_data.input_window_seconds and nibble_count >= detected_fish.fish_data.nibbles_before_flee:
		detected_fish.queue_free()
		timer = 0.0
		nibble_count = 0
		failure_chord_player_fs.play()
		return

	if timer >= detected_fish.fish_data.input_window_seconds and nibble_count < detected_fish.fish_data.nibbles_before_flee:
		nibble_count += 1
		bobber_anim_player.play("bob")
		add_camera_shake.emit(0.8)
		timer = 0.0
		nibble_player.play()


func _on_cancel_reeling_area_body_entered(body: Node3D) -> void:
	cancel_reeling = true

extends State
class_name ReelingState


@export var casting_state: State
@export var hooked_state: State


@onready var bobber: CharacterBody3D = %BobberTest


var bobber_speed: float = 500.0
var detected_fish: TestFish = null


func _on_fish_detector_body_entered(fish: CharacterBody3D) -> void:
	print("fish detected")
	if fish is TestFish:
		detected_fish = fish


func enter(_previous_state: State) -> void:
	print("reeling state")
	bobber.position = Vector3.ZERO
	detected_fish = null

	bobber.visible = true


func exit() -> void:
	bobber.visible = false


func physics_update(delta: float) -> State:
	_move_bobber(delta)

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

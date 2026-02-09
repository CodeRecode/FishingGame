class_name InputButton
extends Button


@export var press_input_action: String


func _ready() -> void:
	InputManager.on_input_type_changed.connect(_on_input_type_changed)


func _input(event: InputEvent) -> void:
	if press_input_action == "":
		return
		
	if is_visible_in_tree() && event.is_action_pressed(press_input_action, true):
		emit_signal("pressed")
		get_viewport().set_input_as_handled()


func _on_input_type_changed(_type: InputManager.InputType) -> void:
	icon = InputManager.get_prompt_texture(press_input_action)

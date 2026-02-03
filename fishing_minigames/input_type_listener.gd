extends Node
class_name InputTypeListener


signal last_input_was_kbm(value: bool)


enum InputType {
	KBM,
	CONTROLLER
}


var last_input_type: InputType = InputType.KBM


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		last_input_type = InputType.KBM
	elif event is InputEventMouseButton and event.pressed:
		last_input_type = InputType.KBM
	elif event is InputEventMouseMotion:
		last_input_type = InputType.KBM
	elif event is InputEventJoypadButton and event.pressed:
		last_input_type = InputType.CONTROLLER
	elif event is InputEventJoypadMotion:
		if abs(event.axis_value) > 0.2:
			last_input_type = InputType.CONTROLLER

	if last_input_type == InputType.KBM:
		last_input_was_kbm.emit(true)
	else:
		last_input_was_kbm.emit(false)

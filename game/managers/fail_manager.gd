class_name FailManager
extends BaseManager


@export var fail_ui: Control;


func _init() -> void:
	_state_to_activate = Game.State.FAIL


func _on_ready() -> void:
	fail_ui.visible = false


func _on_activate() -> void:
	fail_ui.visible = true
	
	
func _on_deactivate() -> void:
	fail_ui.visible = false
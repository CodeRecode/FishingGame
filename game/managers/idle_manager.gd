class_name IdleManager
extends BaseManager

@export var idle_ui: Control;


func _init() -> void:
	_state_to_activate = Game.State.IDLE
	

func _on_activate() -> void:
	idle_ui.visible = true
	
	
func _on_deactivate() -> void:
	idle_ui.visible = false

extends PanelContainer

signal on_close()

func _on_close_pressed() -> void:
	hide()
	on_close.emit()

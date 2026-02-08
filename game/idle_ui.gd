extends Control

signal fish_start_requested()

@onready var settings_menu: PanelContainer = %SettingsMenu
@onready var credits_menu: PanelContainer = %CreditsMenu
@onready var buttons: Control = %Buttons

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_reset()


func _on_main_menu_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		_reset()

func _reset() -> void:
	_close_all_menus()
	buttons.show()

func _close_all_menus() -> void:
	if credits_menu.visible:
		credits_menu.hide()
	elif settings_menu.visible:
		settings_menu.hide()

func _on_settings_button_pressed() -> void:
	_close_all_menus()
	settings_menu.show()
	buttons.hide()


func _on_settings_close_button_pressed() -> void:
	_reset()


func _on_credits_button_pressed() -> void:
	_close_all_menus()
	credits_menu.show()
	buttons.hide()


func _on_credits_close_button_pressed() -> void:
	_reset()

func _on_music_slider_value_changed(value: float) -> void:
	var bus_idx = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_linear(bus_idx, value / 100.)


func _on_effects_slider_value_changed(value: float) -> void:
	var bus_idx = AudioServer.get_bus_index("SoundEffects")
	AudioServer.set_bus_volume_linear(bus_idx, value / 100.)


func _on_start_button_pressed() -> void:
	_close_all_menus()
	fish_start_requested.emit()

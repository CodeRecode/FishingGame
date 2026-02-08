class_name RewardUI
extends Control


signal on_next()


@export var success_text: String = "NICE CATCH!!"
@export var failure_text: String = "FAILURE"


@onready var reward_viewport_container: Container = %RewardViewportContainer
@onready var reward_label: Label = %RewardLabel
@onready var status_label: Label = %StatusLabel
@onready var fish_spinner: Node3D = %FishSpinner


func show_success(catch: FishResource) -> void:
	reward_viewport_container.show()
	
	reward_label.show()
	reward_label.text = catch.display_name
	
	status_label.text = success_text
	
	fish_spinner.add_child(catch.visual.instantiate())


func show_failure() -> void:
	reward_viewport_container.hide()
	reward_label.hide()
	
	status_label.text = failure_text


func _on_next() -> void:
	for child in fish_spinner.get_children():
		child.queue_free()
	on_next.emit()

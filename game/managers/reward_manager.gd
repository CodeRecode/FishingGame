class_name RewardManager
extends BaseManager

@export var reward_ui: Control;
@export var reward_label: Label;
@export var reward_audio: AudioStreamPlayer;

func _init() -> void:
	_state_to_activate = Game.State.REWARD
	

func _on_catch(catch: FishResource):
	if reward_label:
		reward_label.text = catch.display_name


func _on_ready() -> void:
	reward_ui.visible = false
	game.on_catch.connect(_on_catch)


func _on_activate() -> void:
	reward_ui.visible = true
	reward_audio.play(.2)


func _on_deactivate() -> void:
	reward_ui.visible = false
	reward_audio.stop()

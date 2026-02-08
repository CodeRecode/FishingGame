class_name RewardManager
extends BaseManager


@export var reward_ui: RewardUI;
@export var reward_audio: AudioStreamPlayer;


func _init() -> void:
	_state_to_activate = Game.State.REWARD


func _succeed_catch(catch: FishResource):
	reward_audio.play(.2)
	reward_ui.show_success(catch)


func _fail_catch():
	reward_ui.show_failure()


func _on_ready() -> void:
	reward_ui.visible = false
	game.on_succeed_catch.connect(_succeed_catch)
	game.on_fail_catch.connect(_fail_catch)


func _on_activate() -> void:
	reward_ui.visible = true


func _on_deactivate() -> void:
	reward_ui.visible = false
	reward_audio.stop()

extends Node

@export var game_scene: PackedScene


func change_to_game_scene() -> void:
	get_tree().change_scene_to_packed(game_scene)

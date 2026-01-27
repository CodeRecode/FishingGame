class_name Journal
extends Node

var catch_counts: Dictionary = {}


func add_catch(catch:FishResource):
	if !catch_counts[catch.id]:
		catch_counts[catch.id] = 0
	catch_counts[catch.id] += 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

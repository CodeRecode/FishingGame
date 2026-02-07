extends CharacterBody3D
class_name CastingIndicator


@onready var target_indicator: CSGCylinder3D = $TargetIndicator
@onready var accuracy_indicator: CSGTorus3D = $AccuracyIndicator


var acc_start_inner_radius: float = 0.0
var acc_start_outer_radius: float = 0.0
var acc_inner_max_radius: float = 25.0
var acc_outer_max_radius: float = 25.5

var speed: float = 1000.0

var casting_started: bool = false


func _ready() -> void:
	acc_start_inner_radius = accuracy_indicator.inner_radius
	acc_start_outer_radius = accuracy_indicator.outer_radius
	accuracy_indicator.visible = false


func reset() -> void:
	accuracy_indicator.inner_radius = acc_start_inner_radius
	accuracy_indicator.outer_radius = acc_start_outer_radius
	accuracy_indicator.visible = false
	casting_started = false


func start_casting_test() -> void:
	accuracy_indicator.visible = true
	casting_started = true

	accuracy_indicator.inner_radius = acc_inner_max_radius
	accuracy_indicator.outer_radius = acc_outer_max_radius


func update_casting_visual(progress: float) -> void:
	accuracy_indicator.inner_radius = lerp(acc_inner_max_radius, acc_start_inner_radius, progress)
	accuracy_indicator.outer_radius = lerp(acc_outer_max_radius, acc_start_outer_radius, progress)

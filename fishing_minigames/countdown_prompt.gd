extends TextureProgressBar
class_name CountdownPrompt


@onready var label: RichTextLabel = %RichTextLabel


func configure_prompt(new_value: float, new_max_value: float) -> void:
	self.value = new_value
	self.max_value = new_max_value


func set_visibility(new_value: bool) -> void:
	self.visible = new_value
	label.visible = new_value


func update_visual(camera: Camera3D, target_pos: Vector3, new_text: String) -> void:
	var screen_position: Vector2 = camera.unproject_position(target_pos)
	position = screen_position - (self.size / 2)
	label.text = new_text

extends TextureProgressBar
class_name CountdownPrompt


#region Input Atlas Coords
const UPDPAD: Rect2 = Rect2(
				Vector2(128,64),
				Vector2(64,64)
			)

const WKEY: Rect2 = Rect2(
				Vector2(512,128),
				Vector2(64,64)
			)

const DOWNDPAD: Rect2 = Rect2(
				Vector2(320,192),
				Vector2(64,64)
			)

const SKEY: Rect2 = Rect2(
				Vector2(640,256),
				Vector2(64,64)
			)

const LEFTDPAD: Rect2 = Rect2(
				Vector2(192,128),
				Vector2(64,64)
			)

const AKEY: Rect2 = Rect2(
				Vector2(320,896),
				Vector2(64,64)
			)

const RIGHTDPAD: Rect2 = Rect2(
				Vector2(0,64),
				Vector2(64,64)
			)

const DKEY: Rect2 = Rect2(
				Vector2(384,640),
				Vector2(64,64)
			)

const ABUTTON: Rect2 = Rect2(
				Vector2(256,0),
				Vector2(64,64)
			)

const SPACE: Rect2 = Rect2(
				Vector2(448,192),
				Vector2(64,64)
			)
#endregion


@onready var controller_prompt: TextureButton = $ControllerPrompt
@onready var kbm_prompt: TextureButton = $KBMousePrompt


var last_input_was_kbm: bool = true
var controller_atlas: AtlasTexture = AtlasTexture.new()
var kbm_atlas: AtlasTexture = AtlasTexture.new()


func _ready() -> void:
	controller_atlas.atlas = load("res://ui/ui_input_prompts/playdate_sheet_default.png")
	kbm_atlas.atlas = load("res://ui/ui_input_prompts/keyboard-&-mouse_sheet_default.png")

	controller_prompt.texture_normal = controller_atlas.atlas
	kbm_prompt.texture_normal = kbm_atlas.atlas


func _on_input_type_listener_last_input_was_kbm(_value: bool) -> void:
	last_input_was_kbm = _value


func configure_prompt(new_value: float, new_max_value: float) -> void:
	self.value = new_value
	self.max_value = new_max_value


func set_visibility(new_value: bool) -> void:
	self.visible = new_value

	if last_input_was_kbm:
		kbm_prompt.visible = new_value
	else:
		controller_prompt.visible = new_value


func update_visual(camera: Camera3D, target_pos: Vector3, new_text: String) -> void:
	var screen_position: Vector2 = camera.unproject_position(target_pos)
	position = screen_position - (self.size / 2)

	match new_text:
		"UP":
			controller_atlas.region = UPDPAD
			kbm_atlas.region = WKEY
		"DOWN":
			controller_atlas.region = DOWNDPAD
			kbm_atlas.region = SKEY
		"LEFT":
			controller_atlas.region = LEFTDPAD
			kbm_atlas.region = AKEY
		"RIGHT":
			controller_atlas.region = RIGHTDPAD
			kbm_atlas.region = DKEY
		"BOTTOM_ACTION":
			controller_atlas.region = ABUTTON
			kbm_atlas.region = SPACE

	controller_prompt.texture_normal = controller_atlas
	kbm_prompt.texture_normal = kbm_atlas

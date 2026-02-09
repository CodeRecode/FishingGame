extends Node

#region Input Atlas Coords

#region Input Atlas Coords
const PROMPT_RECTS := {
	"KEY_SPACE": Rect2(Vector2(448,192), Vector2(64,64)),

	"KEY_W":     	Rect2(Vector2(512,128), Vector2(64,64)),
	"KEY_A":    	Rect2(Vector2(320,896), Vector2(64,64)),
	"KEY_S":     	Rect2(Vector2(640,256), Vector2(64,64)),
	"KEY_D":     	Rect2(Vector2(384,640), Vector2(64,64)),
	#"KEY_ESCAPE":   Rect2i(128, 0, 64, 64),

	"PAD_FACE_DOWN": Rect2(Vector2(0,256), Vector2(64,64)),
	#"PAD_FACE_RIGHT":  Rect2i(64, 128, 64, 64),
	#"PAD_FACE_LEFT":  Rect2i(128, 128, 64, 64),
	#"PAD_FACE_UP": Rect2i(192, 128, 64, 64),

	"PAD_DPAD_UP": 		Rect2(Vector2(128,64), Vector2(64,64)),
	"PAD_DPAD_DOWN":	Rect2(Vector2(320,192), Vector2(64,64)),
	"PAD_DPAD_LEFT":	Rect2(Vector2(192,128), Vector2(64,64)),
	"PAD_DPAD_RIGHT":	Rect2(Vector2(0,64), Vector2(64,64)),
}
#endregion

enum InputType {
	MKB,
	GAMEPAD
}

signal on_input_type_changed(type: InputType)


var _current_input_type: InputType
var _gamepad_atlas: AtlasTexture = AtlasTexture.new()
var _mkb_atlas: AtlasTexture = AtlasTexture.new()

func _ready() -> void:
	_gamepad_atlas.atlas = load("res://ui/ui_input_prompts/playdate_sheet_default.png")
	_mkb_atlas.atlas = load("res://ui/ui_input_prompts/keyboard-&-mouse_sheet_default.png")
	Input.joy_connection_changed.connect(_on_joy_connection_changed)


func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		_set_current_input_type(InputType.GAMEPAD)
	else:
		_set_current_input_type(InputType.MKB)


func _set_current_input_type(type: InputType) -> void:
	if type == _current_input_type:
		return
	_current_input_type = type
	on_input_type_changed.emit(type)


func _on_joy_connection_changed(_device: int, connected: bool) -> void:
	if connected:
		_set_current_input_type(InputType.GAMEPAD)


func get_prompt_texture(action: String) -> Texture2D:
	var prompt_id := _get_prompt_id_for_action(action, _current_input_type)
	if prompt_id == "":
		return null
	return _texture_from_prompt_id(prompt_id)


func _get_prompt_id_for_action(action: String, type: InputType) -> String:
	var events := InputMap.action_get_events(action)
	if events.is_empty():
		return ""
	
	for event in events:
		var prompt_id: String = ""
		if type == InputType.GAMEPAD:
			prompt_id = _event_to_prompt_id_gamepad(event)	
		else:
			prompt_id = _event_to_prompt_id_mkb(event)
		if prompt_id != "":
			return prompt_id
	return ""
	
	
func _event_to_prompt_id_mkb(event: InputEvent) -> String:
	if not (event is InputEventKey):
		return ""

	var event_key := event as InputEventKey

	var code: int = event_key.keycode

	if code == 0:
		code = event_key.physical_keycode

	var key_string := OS.get_keycode_string(code)
	if key_string.is_empty():
		return ""

	key_string = key_string.to_upper().replace(" ", "_")
	return "KEY_%s" % key_string
	
func _event_to_prompt_id_gamepad(event: InputEvent) -> String:
	if event is InputEventJoypadButton:
		match event.button_index:
			JOY_BUTTON_A: return "PAD_FACE_DOWN"
			JOY_BUTTON_B: return "PAD_FACE_RIGHT"
			JOY_BUTTON_X: return "PAD_FACE_LEFT"
			JOY_BUTTON_Y: return "PAD_FACE_UP"
			
			JOY_BUTTON_DPAD_DOWN: return "PAD_DPAD_DOWN"
			JOY_BUTTON_DPAD_RIGHT: return "PAD_DPAD_RIGHT"
			JOY_BUTTON_DPAD_LEFT: return "PAD_DPAD_LEFT"
			JOY_BUTTON_DPAD_UP: return "PAD_DPAD_UP"
	return ""

func _texture_from_prompt_id(prompt_id: String) -> Texture2D:
	var rect: Rect2 = PROMPT_RECTS.get(prompt_id, Rect2())
	if rect.size == Vector2.ZERO:
		return null
	var out_tex := AtlasTexture.new()
	if _current_input_type == InputType.GAMEPAD:
		out_tex.atlas = _gamepad_atlas
	else:
		out_tex.atlas = _mkb_atlas
	out_tex.region = rect
	return out_tex

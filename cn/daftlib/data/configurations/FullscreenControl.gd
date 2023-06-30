class_name FullscreenControl
extends IConfigControl

var _control:CheckBox

func _init(check:CheckBox) -> void:
	section = "Display"
	key = "Fullscreen"
	_control = check
	
	var is_fullscreen:bool = DisplayObjectUtil.getFullScreen()
	check.button_pressed = is_fullscreen
	check.toggled.connect(_onFullscreenCheck)

func _onFullscreenCheck(button_pressed:bool) -> void:
	DisplayObjectUtil.setFullScreen(button_pressed)

func getValue() -> Variant:
	return _control.button_pressed

func setValue(value:Variant) -> void:
	_control.button_pressed = value
	_control.toggled.emit(value)

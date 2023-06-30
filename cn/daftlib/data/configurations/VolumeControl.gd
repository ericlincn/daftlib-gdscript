class_name VolumeControl
extends IConfigControl

var _control:Slider

func _init(slider:Slider, audio_bus:String) -> void:
	section = "Audio"
	key = audio_bus
	_control = slider
	
	var volume = SoundUtil.getVolumeForBus(audio_bus)
	slider.min_value = -55
	slider.max_value = 5
	slider.step = 5
	slider.value = volume
	slider.value_changed.connect(_onVolumeChange.bind(audio_bus))

func _onVolumeChange(value:float, audio_bus:String) -> void:
	SoundUtil.setVolumeForBus(audio_bus, value)

func getValue() -> Variant:
	return _control.value

func setValue(value:Variant) -> void:
	_control.value = value
	_control.value_changed.emit(value)

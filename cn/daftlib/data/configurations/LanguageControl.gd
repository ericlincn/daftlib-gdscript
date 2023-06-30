class_name LanguageControl
extends IConfigControl

var _control:OptionButton
# Sample: ["en", "ja", "zh"]
var _lang_keys:Array[String]

func _init(button:OptionButton, lang_keys:Array[String]) -> void:
	section = "Localization"
	key = "Language"
	_control = button
	_lang_keys = lang_keys
	
	button.item_selected.connect(_onLangSelected)
	var _os_lang = OSUtil.getLanguage()
	var i = clamp(_lang_keys.find(_os_lang), 0, _lang_keys.size() - 1)
	button.selected = i
	
func _onLangSelected(index) -> void:
	TranslationServer.set_locale(_lang_keys[index])

func getValue() -> Variant:
	return _control.selected

func setValue(value:Variant) -> void:
	_control.selected = value
	_control.item_selected.emit(value)

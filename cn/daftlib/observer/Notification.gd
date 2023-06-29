class_name Notification

var _n:String
var name:String:
	get:
		return _n

var _b:Variant
var body:Variant:
	get:
		return _b

func _init(_name:String, _body:Variant) -> void:
	self._n = _name
	self._b = _body

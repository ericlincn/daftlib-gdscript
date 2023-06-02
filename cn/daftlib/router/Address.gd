class_name Address

signal change(value:String)

var _history:Array[String]
var _index:int

func _init():
	clear()

func setValue(value:String):
	if value.length() == 0:
		value = "/"
	elif value.left(1) != "/":
		value = "/" + value
	
	if value.length() > 1:
		value = value.rstrip("/")
	
	if _history[_index] == value: return

	_set_current(value)

func up():
	var current:String = _history[_index]
	if current == "/": return
	
	current = current.rstrip("/")
	var last_slash_index = current.rfind("/")
	if last_slash_index == 0 or last_slash_index == -1:
		setValue("/")
	else:
		setValue(current.substr(0, last_slash_index))

func _set_current(value:String):
	if _index < _history.size() - 1:
		_history = _history.slice(0, _index + 1)
	
	_history.append(value)
	_index += 1
	change.emit(value)

func getValue():
	return _history[_index]

func back():
	if _index == 0: return
	
	_index -= 1
	change.emit(_history[_index])

func forward():
	if _index == _history.size() - 1: return
	
	_index += 1
	change.emit(_history[_index])

func clear():
	_history = ["/"]
	_index = 0

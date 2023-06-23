## Usage:
## 
## var address:Address = Address.new()
## address.change.connect(on_address_change)
## address.setValue("/learn/")
## address.setValue("")
## address.setValue("/blog/articles/godot")
## address.up()
## address.setValue("contact")
## address.setValue("news")
## address.back()
## address.setValue("/about")
## address.forward()
## address.back()
## 
## func on_address_change(value):
## 	print(value)

class_name Address

extends IRouter

signal change(value:String)

var _history:Array[String]
var _index:int

func _init() -> void:
	clear()

func clear() -> void:
	_history = ["/"]
	_index = 0

func setValue(value:String) -> void:
	if value.length() == 0:
		value = "/"
	elif value.left(1) != "/":
		value = "/" + value
	
	if value.length() > 1:
		value = value.rstrip("/")
	
	if _history[_index] == value: return

	_set_current(value)

func _set_current(value:String) -> void:
	if _index < _history.size() - 1:
		_history = _history.slice(0, _index + 1)
	
	_history.append(value)
	_index += 1
	change.emit(value)

func getValue() -> String:
	return _history[_index]

func getPreviousValue() -> String:
	var i = _index
	if i > 0: i -= 1
	return _history[i]

func up() -> void:
	var current:String = _history[_index]
	if current == "/": return
	
	current = current.rstrip("/")
	var last_slash_index = current.rfind("/")
	if last_slash_index == 0 or last_slash_index == -1:
		setValue("/")
	else:
		setValue(current.substr(0, last_slash_index))

func back() -> void:
	if _index == 0: return
	
	_index -= 1
	change.emit(_history[_index])

func forward() -> void:
	if _index == _history.size() - 1: return
	
	_index += 1
	change.emit(_history[_index])

func isRoot() -> bool:
	return getValue() == "/"

extends Node

var _signal_map:Dictionary = {}

func connectSignal(_signal:Signal, callable:Callable) -> void:
	
	if _signal_map.get(_signal):
		var callable_list:Array= _signal_map.get(_signal)
		var i := callable_list.size()
		while i > 0:
			i -= 1
			if callable_list[i] == callable:
				return
		callable_list.append(callable)
		_signal.connect(callable)
	else:
		_signal_map[_signal] = [callable]
		_signal.connect(callable)

func disconnectSignal(_signal:Signal, callable:Callable) -> void:
	
	if _signal_map.get(_signal) == null: return

	var callable_list:Array = _signal_map.get(_signal)
	var i := callable_list.size()
	while i > 0:
		i -= 1
		if callable_list[i] == callable:
			callable_list.remove_at(i)
			_signal.disconnect(callable)

	if callable_list.size() == 0:
		_signal_map.erase(_signal)

func disconnectAllForSignal(_signal:Signal) -> void:
	
	if _signal_map.get(_signal) == null: return

	var callable_list:Array = _signal_map.get(_signal)
	var i := callable_list.size()
	while i > 0:
		i -= 1
		var callable:Callable = callable_list[i]
		_signal.disconnect(callable)
	
	_signal_map.erase(_signal)

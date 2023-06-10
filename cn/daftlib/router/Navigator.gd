class_name Navigator

extends Node

signal change(id:String, data:Dictionary)
signal finished(id_list:Array)

#var currentId:String:
#	get:
#		return _currentId

var _id_list:Array[String]
var _data_dict:Dictionary
var _currentId:String

func setData(source:Array):
	_id_list = []
	_data_dict = {}
	_currentId = ""
	
	for item in source:
		var id:String = item.get("id")
		_id_list.append(id)
		if _data_dict.get(id):
			push_error("Id: %s already exist" % [id])
		_data_dict[id] = item
	print("[Navigator] Data count: ", _id_list.size())

func setId(id:String):
	if _currentId == id:
		return
	
	_currentId = id
	change.emit(id, _data_dict.get(id))

func next():
	if _currentId == "":
		first()
	else:
		var currentIndex = _id_list.find(_currentId)
		var targetIndex = currentIndex + 1
		if targetIndex >= _id_list.size():
			finished.emit(_id_list)
		else:
			var id:String = _id_list[targetIndex]
			var data:Dictionary = _data_dict[id]
			if _checkCondition(data) == true:
				setId(_id_list[targetIndex])
			else:
				print("[Navigator] Id: ", id, " condition not met, skipping...")
				_currentId = id
				# Skip to next scene, try to met condition again
				next()

func first():
	setId(_id_list[0])

func _checkCondition(_data:Dictionary):
	return true

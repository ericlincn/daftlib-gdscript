class_name Navigator

extends IRouter

signal change(id:String, data:Dictionary)
signal finished(id_list:Array)

var _id_list:Array[String]
var _data_dict:Dictionary
var _id:String

# Data sample:
#[
#  {
#    "id": "scene1",
#    "packed_res": "res://assets/scenes/scene1.tscn",
#    "dialogues": []
#  },
#  {
#    "id": "scene2",
#    "packed_res": "res://assets/scenes/scene2.tscn",
#    "dialogues": []
#  },
#  {
#    "id": "scene3",
#    "packed_res": "res://assets/scenes/scene3.tscn",
#    "dialogues": []
#  }
#]

func setData(source:Array) -> void:
	_id_list = []
	_data_dict = {}
	_id = ""
	
	for item in source:
		var id:String = item.get("id")
		_id_list.append(id)
		if _data_dict.get(id):
			push_error("ID: %s already exist" % [id])
		_data_dict[id] = item
	print("[Navigator] Data count: ", _id_list.size())

func setValue(value:String) -> void:
	if _id == value:
		return
	
	_id = value
	change.emit(_id, _data_dict.get(value))

func getValue() -> String:
	return _id

func forward() -> void:
	if _id == "":
		first()
	else:
		var currentIndex = _id_list.find(_id)
		var targetIndex = currentIndex + 1
		if targetIndex >= _id_list.size():
			finished.emit(_id_list)
		else:
			var id:String = _id_list[targetIndex]
			var data:Dictionary = _data_dict[id]
			if _check_condition(data) == true:
				setValue(_id_list[targetIndex])
			else:
				print("[Navigator] ID: ", id, " condition not met, skipping...")
				# Skip to next scene, try to met condition again
				_id = id
				forward()

func first() -> void:
	setValue(_id_list[0])

func _check_condition(_data:Dictionary) -> bool:
	return true

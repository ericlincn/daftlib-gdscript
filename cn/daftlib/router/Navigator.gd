## Usage:
## 
## {
##   "scenes": [
## 	{
## 	  "id": "scene1",
## 	  "packed_res": "res://assets/scenes/scene1.tscn",
## 	  "dialogues": []
## 	},
## 	{
## 	  "id": "scene2",
## 	  "packed_res": "res://assets/scenes/scene2.tscn",
## 	  "dialogues": []
## 	},
## 	{
## 	  "id": "scene3",
## 	  "packed_res": "res://assets/scenes/scene3.tscn",
## 	  "dialogues": []
## 	}
##   ]
## }
## 
## for item in data.scenes:
## 	var sceneId:String = item.get("id")
## 	Navigator.link(sceneId, item)
## 
## Navigator.change.connect(onSceneChanged)
## Navigator.finished.connect(onAllSceneFinished)
## Navigator.first()
## 
## func onSceneChange(_id:String, data:Variant):
## 	print(data.get("packed_res"))
## 	SceneManager.changeScene(data)

class_name Navigator

extends IRouter

signal change(value:String, data:Variant)
signal finished

var _value_list:Array[String]
var _value:String
var _data_dict:Dictionary

func _init() -> void:
	clear()

func clear() -> void:
	_value_list = []
	_value = ""
	_data_dict = {}

func link(value:String, data:Variant) -> void:
	if _data_dict.get(value):
		push_error("Value as key: %s already exist" % [value])
	else:
		_value_list.append(value)
		_data_dict[value] = data

func setValue(value:String) -> void:
	if _data_dict.get(value) == null:
		return
	
	if _value == value:
		return
	
	_value = value
	change.emit(_value, _data_dict.get(value))

func getValue() -> String:
	return _value

func forward() -> void:
	if _value == "":
		first()
	else:
		var currentIndex = _value_list.find(_value)
		var targetIndex = currentIndex + 1
		if targetIndex >= _value_list.size():
			finished.emit()
		else:
			var value:String = _value_list[targetIndex]
			var data:Variant = _data_dict[value]
			if _check_condition(data) == true:
				setValue(_value_list[targetIndex])
			else:
				print("[Navigator] Value: ", value, " condition not met, skipping...")
				# Skip to next scene, try to met condition again
				_value = value
				forward()

func first() -> void:
	setValue(_value_list[0])

func _check_condition(_data:Variant) -> bool:
	return true

## Usage:
## 
## ql = QueueLoader.new()
## ql.progress.connect(onProgress)
## ql.complete.connect(onComplete)
## ql.addItem("res://assets/art/enemyFlyingAlt_1.png")
## ql.addItem("res://assets/art/enemyFlyingAlt_2.png")
## ql.addItem("res://assets/art/enemySwimming_1.png", true)
## ql.addItem("res://assets/art/enemySwimming_2.png", true)
## ql.addItem("res://assets/art/enemyWalking_1.png")
## ql.addItem("res://assets/art/enemyWalking_2.png")
## ql.addItem("res://assets/art/House In a Forest Loop.ogg")
## ql.addItem("res://assets/scene.tscn")
## ql.start()
## self.add_child(ql)
## 
## func onComplete():
## 	$Sprite2D.texture = ql.getItem("res://assets/art/enemyWalking_2.png")
##	var res = ql.getItem("res://assets/scene.tscn")
##	var instance = res.instantiate()
## 
## func onProgress(percent):
## 	print(percent)

class_name QueueLoader

extends Node

signal complete
signal progress(percent:float)

var __items:Array[Array] = []
var __loaded:Dictionary = {}
var __itemsLoaded:int = 0

func _init() -> void:
	self.clear()

func clear() -> void:
	self.__items = []
	self.__loaded = {}

func addItem(url, use_sub_threads:bool = false) -> void:
	for item in __items:
		if item[0] == url:
			return
	self.__items.append([url, use_sub_threads])

func start() -> void:
	if len(self.__items) <= 0:
		push_error("Error: Loading queue is empty")
	
	self.__itemsLoaded = 0
	self.__load(self.__itemsLoaded)

func getItem(key:String) -> Variant:
	if key in self.__loaded:
		return self.__loaded.get(key)
	return null

func __load(index:int) -> void:
	var item = self.__items[index]
	var url = item[0]
	var use_sub_threads = item[1]
	var error = ResourceLoader.load_threaded_request(url, "", use_sub_threads)
	if error != OK:
		push_error("Error: %s loading failed" % [url])

func _process(_delta) -> void:
	if len(self.__items) > 0:
		var item = self.__items[self.__itemsLoaded]
		var url = item[0]
		var arr = []
		var status = ResourceLoader.load_threaded_get_status(url, arr)
		var singlePercent = arr[0] as float * 1.0
		
		if status == ResourceLoader.THREAD_LOAD_FAILED:
			push_error("Error: %s loading failed" % [url])
			
		elif status == ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			push_error("Error: %s is invalid resource" % [url])
			
		elif status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			var percentLoaded = singlePercent + self.__itemsLoaded
			var percentTotal = len(self.__items)
			self.emit_signal("progress", percentLoaded / percentTotal)
			
		elif status == ResourceLoader.THREAD_LOAD_LOADED:
			var percentLoaded = 1.0 + self.__itemsLoaded
			var percentTotal = len(self.__items)
			self.emit_signal("progress", percentLoaded / percentTotal)
			self.__loaded[url] = ResourceLoader.load_threaded_get(url)

			self.__itemsLoaded += 1
			if self.__itemsLoaded >= len(self.__items):
				self.emit_signal("complete")
				self.__items = []
			else:
				self.__load(self.__itemsLoaded)

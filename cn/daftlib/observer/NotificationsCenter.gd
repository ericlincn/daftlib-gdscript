extends Node

var __observerMap:Dictionary = {}

func register(notificationName:String, observer) -> void:

	if __observerMap.get(notificationName):
		var observersArr:Array = __observerMap.get(notificationName)
		var i := len(observersArr)
		while i > 0:
			i -= 1
			if observersArr[i] == observer:
				return
		observersArr.append(observer)
	else:
		__observerMap[notificationName] = [observer]

func sendNotification(notificationName:String, data:Variant) -> void:

	if __observerMap.get(notificationName) == null: return

	var observersArr:Array = __observerMap.get(notificationName)
	var i := 0
	while i < len(observersArr):
		var observer = observersArr[i]
		var callback:Callable = observer.notificationHandler
		var notification:Notification = Notification.new(notificationName, data)
		callback.call(notification)
		i += 1

func unregisterForNotification(notificationName:String) -> void:
	__observerMap.erase(notificationName)

func unregisterForObserver(observer) -> void:

	for key in __observerMap:
		var observersArr:Array = __observerMap[key]

		var i := len(observersArr)
		while i > 0:
			i -= 1
			if observersArr[i] == observer:
				observersArr.remove_at(i)

		if len(observersArr) == 0:
			__observerMap.erase(key)

func unregister(notificationName:String, observer) -> void:
	
	if __observerMap.get(notificationName) == null: return

	var observersArr:Array = __observerMap.get(notificationName)
	var i := len(observersArr)
	while i > 0:
		i -= 1
		if observersArr[i] == observer:
			observersArr.remove_at(i)

	if len(observersArr) == 0:
		__observerMap.erase(notificationName)

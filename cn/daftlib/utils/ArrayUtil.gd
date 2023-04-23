class_name ArrayUtil

static func shuffle(target:Array) -> void:
	target.shuffle()

static func sortByAttribute(target:Array, attribute:String) -> void:
	target.sort_custom(func(a, b): return a.get(attribute) < b.get(attribute))

static func switchElements(target:Array, index1:int, index2:int) -> void:
		var a = target[index1]
		var b = target[index2]
		target[index1] = b
		target[index2] = a

static func getDistinctList(target:Array) -> Array:
	var obj = {}
	var lambda = func filter_fn(item):
			if not obj.get(item):
				obj[item] = true
				return true
			else:
				return false
	return target.filter(lambda)

static func getShortDistance(index1:int, index2:int, length:int) -> int:
		const MAX_VALUE: int = 2147483647
		
		var min_index = min(index1, index2)
		var max_index = max(index1, index2)

		if max_index >= length:
			return MAX_VALUE

		var dist = index2 - index1
		if abs(dist) <= (length as float/ 2):
			return dist
		else:
			return int(-dist / abs(dist) * (min_index + length - max_index))

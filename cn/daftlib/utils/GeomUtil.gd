class_name GeomUtil

static func getScaleRatioToFill(original:Vector2, target:Vector2) -> float:
	var widthRatio:float = target.x as float/ original.x
	var heightRatio:float = target.y as float / original.y
	return max(widthRatio, heightRatio);

static func getScaleRatioToFit(original:Vector2, target:Vector2) -> float:
	var widthRatio:float = target.x as float/ original.x
	var heightRatio:float = target.y as float / original.y
	return min(widthRatio, heightRatio)

static func getPositionToCenter(original:Vector2, target:Vector2) -> Vector2:
	return Vector2((target.x - original.x) * .5, (target.y - original.y) * .5)

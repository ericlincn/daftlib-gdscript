class_name GeomUtil

static func getScaleRatioToFill(original:Vector2, target:Vector2):
	var widthRatio:float = target.x as float/ original.x
	var heightRatio:float = target.y as float / original.y
	return max(widthRatio, heightRatio);

static func getScaleRatioToFit(original:Vector2, target:Vector2):
	var widthRatio:float = target.x as float/ original.x
	var heightRatio:float = target.y as float / original.y
	return min(widthRatio, heightRatio)

static func getPositionToCenter(original:Vector2, original_scale:float, target:Vector2):
	var new_size = Vector2(original.x as float * original_scale, original.y as float * original_scale)
	return Vector2((target.x - new_size.x) * .5, (target.y - new_size.y) * .5)

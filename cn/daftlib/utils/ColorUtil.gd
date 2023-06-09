class_name ColorUtil

static func getRandomColor() -> Color:
	return Color(randf(), randf(), randf())

static func getGray(gray8:float) -> Color:
	var gray = max(0, min(255, gray8)) / 255
	return Color(gray, gray, gray)

static func isDarkColor(color:Color) -> bool:
	var perceivedLuminosity = (0.299 * color.r8 + 0.587 * color.g8 + 0.114 * color.b8)
	return perceivedLuminosity < 70

static func getDifference(color1:Color, color2:Color) -> float:
	var averageR := (color1.r8 + color2.r8) * 0.5
	var diff := ((2 + averageR / 255) * pow(color1.r8 - color2.r8, 2) + 4 * pow(color1.g8 - color2.g8, 2) + (2 + (255 - averageR) / 255) * pow(color1.b8- color2.b8, 2)) / (3 * 255) / (3 * 255)
	return diff

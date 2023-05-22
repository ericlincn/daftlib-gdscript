class_name DisplayObjectUtil

static func getScreenShotImage(target:Node):
	var _root = target.get_tree().root
	return _root.get_texture().get_image()

static func getScreenShotImageTexture(target:Node):
	var image = getScreenShotImage(target)
	return ImageTexture.create_from_image(image)

static func getSingleColorImage(size:Vector2, color:Color):
	var image:Image = Image.create(int(size.x), int(size.y), false, Image.FORMAT_RGBA8)
	image.fill(color)
	return image

static func getSingleColorImageTexture(size:Vector2, color:Color):
	var image:Image = getSingleColorImage(size, color)
	return ImageTexture.create_from_image(image)

static func setDisableInput(target:Node, disable:bool):
	target.get_tree().root.gui_disable_input = disable

static func getCorrectionForAspectRatio(texture:Texture2D):
	var game_width:float = ProjectSettings.get_setting("display/window/size/viewport_width")
	var game_height:float = ProjectSettings.get_setting("display/window/size/viewport_height")
	var scale:float = GeomUtil.getScaleRatioToFill(texture.get_size(), Vector2(game_width, game_height))
	return Vector2(scale, scale)

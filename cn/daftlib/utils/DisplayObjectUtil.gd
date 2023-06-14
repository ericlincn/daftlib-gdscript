class_name DisplayObjectUtil

static func getScreenShotImage(target:Node) -> Image:
	var _root := target.get_tree().root
	return _root.get_texture().get_image()

static func getScreenShotImageTexture(target:Node) -> ImageTexture:
	var image = getScreenShotImage(target)
	return ImageTexture.create_from_image(image)

static func getSingleColorImage(size:Vector2, color:Color) -> Image:
	var image:Image = Image.create(int(size.x), int(size.y), false, Image.FORMAT_RGBA8)
	image.fill(color)
	return image

static func getSingleColorImageTexture(size:Vector2, color:Color) -> ImageTexture:
	var image:Image = getSingleColorImage(size, color)
	return ImageTexture.create_from_image(image)

# Get a single colored TextureRect which cover full window,
# such as background, shadered TextureRect
static func getSingleColorFullRect(color:Color) -> TextureRect:
	var rect:TextureRect = TextureRect.new()
	rect.texture = getSingleColorImageTexture(Vector2(64,64), color)
	rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	return rect

static func setDisableInput(target:Node, disable:bool) -> void:
	target.get_tree().root.gui_disable_input = disable

static func getCorrectionForAspectRatio(texture:Texture2D) -> Vector2:
	var game_width:float = ProjectSettings.get_setting("display/window/size/viewport_width")
	var game_height:float = ProjectSettings.get_setting("display/window/size/viewport_height")
	var scale:float = GeomUtil.getScaleRatioToFill(texture.get_size(), Vector2(game_width, game_height))
	return Vector2(scale, scale)

static func hideAllChildrenIn(target:Node) -> void:
	var children:Array = target.get_children()
	for child in children:
		if child.get("visible"):
			child.visible = false

static func removeAllChildrenIn(target:Node) -> void:
	while target.get_child_count() > 0:
		target.remove_child(target.get_child(0))

static func kill() -> void:
	OS.kill(OS.get_process_id())

static func quit(target:Node) -> void:
	target.get_tree().quit()

# Pause the game, include timer, music player
# If the node is "unpauseable", like ui canvaslayer
# add "self.process_mode = Node.PROCESS_MODE_ALWAYS" in the node
static func setPause(target:Node, pause:bool) -> void:
	target.get_tree().paused = pause

static func setFullScreen(fullscreen:bool) -> void:
	if fullscreen == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

static func getFullScreen() -> bool:
	return DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN

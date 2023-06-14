class_name OSUtil

static func herf(url:String) -> Error:
	var error := OS.shell_open(url)
	return error

# ProjectSettings.editor/run/main_run_args
# supports --key value & --key=value 
static func getVars() -> Dictionary:
	var arguments:Dictionary = {}
	for argument in OS.get_cmdline_args():
		if argument.find("=") > -1:
			var key_value = argument.split("=")
			arguments[key_value[0].lstrip("--")] = key_value[1]
		else:
			arguments[argument.lstrip("--")] = ""
	return arguments

static func isDebug() -> bool:
	return OS.is_debug_build()

static func getExecutablePath() -> String:
	return OS.get_executable_path()

static func getScreenDPI() -> int:
	return DisplayServer.screen_get_dpi()

static func getScreenSize() -> Vector2i:
	return DisplayServer.screen_get_size()

static func isTouchScreen() -> bool:
	return DisplayServer.is_touchscreen_available()

static func getProcessorName() -> String:
	return OS.get_processor_name()

static func getProcessorCount() -> int:
	return OS.get_processor_count()

static func getHardwareID() -> String:
	return OS.get_unique_id()

static func getOperationSystemName() -> String:
	return OS.get_name()

static func getVideoCardName() -> String:
	return RenderingServer.get_video_adapter_name()

static func getLocale() -> String:
	return OS.get_locale()

static func getLanguage() -> String:
	return OS.get_locale_language()

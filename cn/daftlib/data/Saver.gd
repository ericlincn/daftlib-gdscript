# Auto load by daftlib.gd

extends Node

const SAVE_PATH:String = "user://"
const SAVE_EXT:String = ".res"

const AUTO_SUFFIX:String = "A"
const AUTO_SLOT_COUNT:int = 3

const THUMB_EXT:String = ".png"
var THUMB_SIZE:Vector2i = Vector2i(160, 90)
var THUMB_COLOR:Color = Color(0, 0, 0)

func save(resource:Resource, image:Image = null) -> String:
	var base := _get_basename_from_time(false)
	_save_on_disk(base, resource, image)
	return base

func overwrite(basename:String, resource:Resource, image:Image = null) -> String:
	deleteSaveAndSnapshot(basename)
	return save(resource, image)

func autosave(resource:Resource, image:Image = null) -> String:
	var base := _get_basename_from_time(true)
	var list := getAutosaveSlots()
	if list.size() >= AUTO_SLOT_COUNT:
		for i in range(list.size() - 1, AUTO_SLOT_COUNT - 2, -1):
			deleteSaveAndSnapshot(list[i])
	
	_save_on_disk(base, resource, image)
	return base

func loadSave(basename:String) -> Resource:
	var full_path = _get_save_full_path(basename)
	if not FileAccess.file_exists(full_path):
		return null
	
	return ResourceLoader.load(full_path).duplicate(true)

func loadLatestSave() -> Resource:
	var slots := getAllSaveSlots()
	return loadSave(slots[0])

func loadLatestAutosave() -> Resource:
	var slots := getAutosaveSlots()
	return loadSave(slots[0])

func loadSnapshot(basename:String) -> ImageTexture:
	if basename.length() <= 0:
		return DisplayObjectUtil.getSingleColorImageTexture(THUMB_SIZE, THUMB_COLOR)
	
	var full_path = _get_snapshot_full_path(basename)
	if not FileAccess.file_exists(full_path):
		return DisplayObjectUtil.getSingleColorImageTexture(THUMB_SIZE, THUMB_COLOR)
	
	var image:Image = Image.new()
	image.load(full_path)
	return ImageTexture.create_from_image(image)

func getSaveSlots() -> Array[String]:
	var file_list := _get_save_file_list()
	for i in range(file_list.size() - 1, -1, -1):
		var f = file_list[i]
		if _is_autosave(f) == true:
			file_list.remove_at(i)
	
	file_list.sort()
	file_list.reverse()
	return file_list

func getAutosaveSlots() -> Array[String]:
	var file_list := _get_save_file_list()
	for i in range(file_list.size() - 1, -1, -1):
		var f = file_list[i]
		if _is_autosave(f) == false:
			file_list.remove_at(i)
	
	file_list.sort()
	file_list.reverse()
	return file_list

func getAllSaveSlots() -> Array[String]:
	var file_list := _get_save_file_list()
	file_list.sort()
	file_list.reverse()
	return file_list

func isSameAsLatestAutosave(save:Resource, keys:Array[String]) -> bool:
	if hasSave() == false: return false
	if getAutosaveSlots().size() == 0: return false
	
	var latest_name = getAutosaveSlots()[0]
	var latest = loadSave(latest_name)
	return _is_same(save, latest, keys)

func hasSave() -> bool:
	return _get_save_file_list().size() > 0

func deleteSaveAndSnapshot(basename:String) -> void:
	var err := DirAccess.remove_absolute(_get_save_full_path(basename))
	if err != OK:
		push_error("[Saver] deleting save failed")
	err = DirAccess.remove_absolute(_get_snapshot_full_path(basename))
	if err != OK:
		push_error("[Saver] deleting snapshot failed")

func getTimeString(basename:String) -> String:
	return _get_time_from_basename(basename)

func _get_save_file_list() -> Array[String]:
	var output:Array[String] = []
	var dir = DirAccess.open(SAVE_PATH)
	if dir:
		var files = dir.get_files()
		for f in files:
			if f.get_extension() == SAVE_EXT.substr(1):
				output.append(f.get_basename())
	return output

func _get_save_full_path(basename:String) -> String:
	return SAVE_PATH + basename + SAVE_EXT

func _get_snapshot_full_path(basename:String) -> String:
	return SAVE_PATH + basename + THUMB_EXT

func _get_basename_from_time(autosave:bool) -> String:
	var n := Time.get_datetime_string_from_system()
	n = n.replace(":", ".")
	n += "_"
	n += str(Time.get_ticks_msec())
	if autosave == true: n += AUTO_SUFFIX
	return n

func _get_time_from_basename(basename:String) -> String:
	var n := basename.replace(AUTO_SUFFIX, "")
	n = n.split("_")[0]
	n = n.replace(".", ":")
	n = n.replace("T", " ")
	return n

func _is_autosave(basename:String) -> bool:
	return basename.contains(AUTO_SUFFIX)

func _is_same(save_a:Resource, save_b:Resource, keys:Array[String]) -> bool:
	var _same:bool = true
	for key in keys:
		_same = _same and (save_a.get(key) == save_b.get(key))
	return _same

func _save_on_disk(basename:String, resource:Resource, image:Image) -> void:
	
	var err := ResourceSaver.save(resource, _get_save_full_path(basename))
	if err != OK:
		push_error("[Saver] saving failed")
	
	if not image:
		image = DisplayObjectUtil.getSingleColorImage(THUMB_SIZE, THUMB_COLOR)
	
	if image.get_size() != THUMB_SIZE:
		image.resize(THUMB_SIZE.x, THUMB_SIZE.y)
	
	err = image.save_png(_get_snapshot_full_path(basename))
	if err != OK:
		push_error("[Saver] saving snapshot failed")

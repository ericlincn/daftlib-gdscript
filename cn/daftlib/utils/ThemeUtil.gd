class_name ThemeUtil

static func overrideThemeStylebox(target:Control, source:String, dist:String) -> void:
	var new_style:StyleBox = target.get_theme_stylebox(dist)
	target.add_theme_stylebox_override(source, new_style)

# Gets Control type
static func getStyleboxTypeList(target:Control) -> PackedStringArray:
	return target.theme.get_stylebox_type_list()

static func getStyleboxList(target:Control, type: String) -> PackedStringArray:
	return target.theme.get_stylebox_list(type)

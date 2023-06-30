# Auto load by daftlib.gd

extends Node

const CONFIG_PATH:String = "user://settings.cfg"

var _controls:Array[IConfigControl] = []

# Call after binds
func loadConfig() -> void:
	var config = ConfigFile.new()
	var err = config.load(CONFIG_PATH)
	if err != OK:
		_creat_config()
		return
	
	# Fetch the data
	for control in _controls:
		var value = config.get_value(control.section, control.key)
		control.setValue(value)

func _creat_config() -> void:
	print("[ProjectConfig] Create new config file")
	save()

# Call after binds
func save() -> void:
	# Create new ConfigFile object.
	var config = ConfigFile.new()

	# Store some values.
	for control in _controls:
		var value = control.getValue()
		config.set_value(control.section, control.key, value)
	
	# Save it to a file (overwrite if already exists).
	config.save(CONFIG_PATH)

func add(control:IConfigControl) -> void:
	_controls.append(control)

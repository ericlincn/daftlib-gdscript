class_name SoundUtil

static func setVolumeForBus(bus_name:String, volume_db:float):
	var id = AudioServer.get_bus_index(bus_name)
	if volume_db <= -55:
		AudioServer.set_bus_mute(id, true)
	elif AudioServer.is_bus_mute(id):
		AudioServer.set_bus_mute(id, false)
	else:
		AudioServer.set_bus_volume_db(id, volume_db)

static func getVolumeForBus(bus_name:String):
	var id = AudioServer.get_bus_index(bus_name)
	return AudioServer.get_bus_volume_db(id)

static func fadeoutAndFree(target:AudioStreamPlayer):
	var tween = target.create_tween()
	tween.tween_property(target, "volume_db", -70, 1)
	tween.tween_callback(target.queue_free)

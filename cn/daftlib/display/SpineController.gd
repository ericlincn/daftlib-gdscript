class_name SpineController

var _sprite:SpineSprite
var _audioHandler:Callable

func _init(target:SpineSprite):
	_sprite = target
#	print(getAnimationNames())

func getAnimationNames():
	# Array[SpineAnimation]
	var arr:Array = _sprite.skeleton_data_res.get_animations()
	var output:Array = []
	for item in arr:
		output.append(item.get_name())
		output.append(item.get_duration())
	return output

func playAnimation(animation_name:String, loop:bool = true, track_id:int = 0):
	_sprite.get_animation_state().set_animation(animation_name, loop, track_id)

func setTimeScale(time_scale:float):
	_sprite.get_animation_state().set_time_scale(time_scale)

func handleSpineAudio(handler:Callable):
	_audioHandler = handler
	_sprite.animation_event.connect(_onSpineEvent)

func _onSpineEvent(_spine_sprite:Object, _animation_state:Object, _track_entry:Object, event:Object):
	var e:SpineEvent = event as SpineEvent
	var data := e.get_data()
	var evt_name := data.get_event_name()
	_audioHandler.call(evt_name)

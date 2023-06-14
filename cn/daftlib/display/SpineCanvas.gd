# Need be attached to CanvasGroup which has a SpineSprite within
class_name SpineCanvas

extends CanvasGroup

@export var animation_name:String = "idle"
@export var animation_loop:bool = true
@export var auto_play:bool = true

signal audio(id:String)

var _sprite:SpineSprite

func _enter_tree() -> void:
	if self.get_child_count() > 1:
		push_error("SpineCanvas must be contains ONE SpineSprite node")
	
	_sprite = self.get_child(0) as SpineSprite
	_sprite.animation_event.connect(_onSpineEvent)

func _ready() -> void:
	if auto_play: playAnimation()
	
func getAnimationNames() -> Array[String]:
	# Array[SpineAnimation]
	var arr:Array = _sprite.skeleton_data_res.get_animations()
	var output:Array[String] = []
	for item in arr:
		output.append(item.get_name() + ":" + str(item.get_duration()))
	return output

func playAnimation() -> void:
	_sprite.get_animation_state().set_animation(animation_name, animation_loop, 0)

func setTimeScale(time_scale:float) -> void:
	_sprite.get_animation_state().set_time_scale(time_scale)

func _onSpineEvent(_spine_sprite:Object, _animation_state:Object, _track_entry:Object, event:Object) -> void:
	var e:SpineEvent = event as SpineEvent
	var data := e.get_data()
	var evt_name := data.get_event_name()
	audio.emit(evt_name)

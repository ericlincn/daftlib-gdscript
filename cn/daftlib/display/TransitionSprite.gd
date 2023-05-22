class_name TransitionSprite

extends Sprite2D

enum FadeType {
	Instant,
	Fade,
	Blend
}

enum FadeDirection {
	In,
	Out
}

signal TransitionComplete

var _total_time:float
var _fade_time_seconds:float
var _type:FadeType
var _direction:FadeDirection
var _shader_pattern:String

func _init(type:FadeType, direction:FadeDirection, duration:float, shaderPattern:String = ""):
	self._type = type if duration > 0 else FadeType.Instant
	self._direction = direction
	
	self._fade_time_seconds = duration if self._type != FadeType.Instant else 0
	self._shader_pattern = shaderPattern
	
	self.centered = false
	
	if self._type == FadeType.Blend:
		self._loadShader()

func _loadShader():
	var shader_material = ShaderMaterial.new()
	shader_material.shader = preload("../shaders/dissolve2d.gdshader")
	shader_material.set_shader_parameter("dissolve_texture", texture)
	self.material = shader_material

	var shader_image = load(self._shader_pattern)
	shader_material.set_shader_parameter("dissolve_texture", shader_image)

func _process(delta:float):
	if _total_time >= _fade_time_seconds:
		self.TransitionComplete.emit()
		queue_free()
	
	_total_time += delta
	var fade_amount = _total_time / _fade_time_seconds
	
	if self._direction == FadeDirection.In:
		fade_amount = 1 - fade_amount
	
	if self._type == FadeType.Fade:
		self.modulate = Color(1, 1, 1, 1 - fade_amount)
	elif self._type == FadeType.Blend:
		self.material.set_shader_parameter("dissolve_amount", fade_amount)

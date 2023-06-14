class_name TransitionSprite

extends Sprite2D

enum Type {
	INSTANT,
	FADE,
	BLEND
}

enum Direction {
	IN,
	OUT
}

signal complete

var _total_time:float
var _fade_time_seconds:float
var _type:Type
var _direction:Direction
var _shader_pattern:String

func _init(type:Type, direction:Direction, duration:float, shader_pattern:String = "") -> void:
	self._type = type if duration > 0 else Type.INSTANT
	self._direction = direction
	
	self._fade_time_seconds = duration if self._type != Type.INSTANT else 0
	self._shader_pattern = shader_pattern

	self.centered = false
	
	if self._type == Type.BLEND:
		self._loadShader()

func _loadShader() -> void:
	var shader_material = ShaderMaterial.new()
	shader_material.shader = preload("../shaders/dissolve.gdshader")
	shader_material.set_shader_parameter("dissolve_texture", texture)
	self.material = shader_material

	var shader_image = load(self._shader_pattern)
	shader_material.set_shader_parameter("dissolve_texture", shader_image)

func _process(delta:float) -> void:
	if _total_time >= _fade_time_seconds:
		self.complete.emit()
		queue_free()
	
	_total_time += delta
	var fade_amount = _total_time / _fade_time_seconds
	
	if self._direction == Direction.IN:
		fade_amount = 1 - fade_amount
	
	if self._type == Type.FADE:
		self.modulate = Color(1, 1, 1, 1 - fade_amount)
	elif self._type == Type.BLEND:
		self.material.set_shader_parameter("dissolve_amount", fade_amount)

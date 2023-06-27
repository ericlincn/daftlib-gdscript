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

var _fade_time_seconds:float
var duration:float:
	set(value):
		_fade_time_seconds = value
var _type:Type
var type:Type:
	set(value):
		_type = value
var _direction:Direction
var direction:Direction:
	set(value):
		_direction = value
var _shader_pattern:String
var shader_pattern_path:String:
	set(value):
		_shader_pattern = value

var _total_time:float = 0.0

func _enter_tree():
	if self._fade_time_seconds == 0: self._type = Type.INSTANT
	if self._type == Type.INSTANT: self._fade_time_seconds = 0
	
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

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

var duration:float
var type:Type
var direction:Direction
var shader_pattern_path:String

var _total_time:float = 0.0

func _enter_tree():
	if self.duration == 0: self.type = Type.INSTANT
	if self.type == Type.INSTANT: self.duration = 0
	
	self.centered = false
	
	if self.type == Type.BLEND:
		self._loadShader()

func _loadShader() -> void:
	var shader_material = ShaderMaterial.new()
	shader_material.shader = preload("../shaders/dissolve.gdshader")
	shader_material.set_shader_parameter("dissolve_texture", texture)
	self.material = shader_material

	var shader_image = load(self.shader_pattern_path)
	shader_material.set_shader_parameter("dissolve_texture", shader_image)

func _process(delta:float) -> void:
	if _total_time >= duration:
		self.complete.emit()
		queue_free()
	
	_total_time += delta
	var fade_amount = _total_time / duration
	
	if self.direction == Direction.IN:
		fade_amount = 1 - fade_amount
	
	if self.type == Type.FADE:
		self.modulate = Color(1, 1, 1, 1 - fade_amount)
	elif self.type == Type.BLEND:
		self.material.set_shader_parameter("dissolve_amount", fade_amount)

func _exit_tree():
	self.texture = null
	self.material = null

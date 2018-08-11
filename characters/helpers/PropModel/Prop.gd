var name
var sprite_path
var offset = Transform2D()
var shape = RectangleShape2D.new()
var scale = Vector2()

func _init(name, sprite_path, offset, shape, scale=Vector2(1,1)):
	self.name = name
	self.sprite_path = sprite_path
	self.offset = offset
	self.shape = shape
	self.scale = scale
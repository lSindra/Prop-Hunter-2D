extends Node

class Prop:
	var sprite_path
	var offset = Transform2D()
	var shape = RectangleShape2D.new()
	var scale = Vector2()
	
	func _init(sprite_path, offset, shape, scale=Vector2(1,1)):
		self.sprite_path = sprite_path
		self.offset = offset
		self.shape = shape
		self.scale = scale

var props = null
var skins = null

func _init():
	var shape1 = RectangleShape2D.new()
	var shape2 = RectangleShape2D.new()
	shape1.set_extents(Vector2(28, 15))
	shape2.set_extents(Vector2(50, 25))
	if props == null:
		props = [Prop.new("res://characters/props/body1.png", Transform2D(0.0, Vector2(0, -61)), shape1),
				Prop.new("res://characters/props/body2.png", Transform2D(0.0, Vector2(0, -61)), shape1),
				Prop.new("res://characters/props/rock.png", Transform2D(0.0, Vector2(0, -10)), shape2)]
	if skins == null:
		skins = [Prop.new("res://characters/skins/rogue/idle00.png", Transform2D(0.0, Vector2(0, -52)), shape1, Vector2(5,5))]

func search_by_sprite_path(sprite_path):
	if props != null:
		var index = 0
		for prop in props:
			if prop.sprite_path == sprite_path:
				return index
			index += 1
	return -1
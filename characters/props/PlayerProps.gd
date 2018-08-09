extends Node

class Prop:
	var sprite_path
	var offset = Transform2D()
	var collision_shape = Vector2()
	
	func _init(sprite_path, offset, collision_shape):
		self.sprite_path = sprite_path
		self.offset = offset
		self.collision_shape = collision_shape

var props = null
var skins = null

func _init():
	if props == null:
		props = [Prop.new("res://characters/props/body1.png", Transform2D(0.0, Vector2(0, -61)), Vector2(50, 50)),
				Prop.new("res://characters/props/body2.png", Transform2D(0.0, Vector2(0, -61)), Vector2(50, 50)),
				Prop.new("res://characters/props/rock.png", Transform2D(0.0, Vector2(0, -10)), Vector2(50, 50))]
	if skins == null:
		skins = [Prop.new("res://characters/skins/body.png", Transform2D(0.0, Vector2(0, -61)), Vector2(50, 50))]
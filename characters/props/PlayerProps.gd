extends Node

class Prop:
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

class Skin extends Prop:
	var idle_anim = null setget ,get_idle_anim
	var running_anim = null setget ,get_running_anim
	
	func _init(name, sprite_path, offset, shape, scale).(name, sprite_path, offset, shape, scale):
		pass
	
	func get_idle_anim():
		if idle_anim == null:
			idle_anim = list_files_with_pattern_in_directory(sprite_path, "idle*")
			print("loading idle_anim")
		return idle_anim
	func get_running_anim():
		if running_anim == null:
			running_anim = list_files_with_pattern_in_directory(sprite_path, "running*")
			print("loading running_anim")
		return running_anim


var props = null
var skins = null

func _init():
	var shape1 = RectangleShape2D.new()
	var shape2 = RectangleShape2D.new()
	shape1.set_extents(Vector2(28, 15))
	shape2.set_extents(Vector2(50, 25))
	if props == null:
		props = [Prop.new("body1" ,"res://characters/props/body1.png", Transform2D(0.0, Vector2(0, -61)), shape1),
				Prop.new("body2" ,"res://characters/props/body2.png", Transform2D(0.0, Vector2(0, -61)), shape1),
				Prop.new("rock" ,"res://characters/props/rock.png", Transform2D(0.0, Vector2(0, -10)), shape2)]
	if skins == null:
		skins = [Skin.new("rogue" ,"res://characters/skins/rogue/", Transform2D(0.0, Vector2(0, -52)), shape1, Vector2(5, 5))]

func search_by_sprite_path(sprite_path):
	if props != null:
		var index = 0
		for prop in props:
			if prop.sprite_path == sprite_path:
				return index
			index += 1
	return -1

#move to file manager singleton
func list_files_with_pattern_in_directory(path, pattern):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			#logic
			if file.match(pattern):
				files.append(file)
		dir.list_dir_end()
	return files

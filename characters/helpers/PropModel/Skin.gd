extends "res://characters/helpers/PropModel/Prop.gd"

var idle_anim = []
var running_anim = []

const FILE_MANAGER = preload("res://characters/helpers/Utils/FileManager.gd")

func _init(name, sprite_path, offset, shape, scale).(name, sprite_path, offset, shape, scale):
	idle_anim = FILE_MANAGER.files_with_pattern_in_directory(sprite_path, "idle*.png")
	running_anim = FILE_MANAGER.files_with_pattern_in_directory(sprite_path, "running*.png")

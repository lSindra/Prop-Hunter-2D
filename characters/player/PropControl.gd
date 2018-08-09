extends Node

var player
var body
var shape
var ray_cast
var current_prop = 0
var prop

func _ready():
	player = $".."
	player.connect("prop_changed", self, '_on_Player_prop_changed')
	player.connect("prop_choose", self, '_on_Player_prop_choose')
	
	ray_cast = $"../RayCast2D"
	ray_cast.connect("prop_choose", self, '_on_Player_prop_choose')
	
	body = get_node(str(player.get_path()) + "/Pivot/Body")
	shape = get_node(str(player.get_path()) + "/Shape")
	
	set_process(false)

func _on_Player_prop_choose(prop_id):
	prop = PlayerProps.props[prop_id]
	change_prop(prop)	

func _on_Player_prop_changed(prop_control):
	current_prop = bind_array(current_prop + prop_control, PlayerProps.props.size())
	
	if current_prop == 0:
		prop = PlayerProps.skins[current_prop]
		change_prop(prop)
	else:
		prop = PlayerProps.props[current_prop - 1]
		change_prop(prop)

func change_prop(prop):
	body.set_texture(load(prop.sprite_path))
	body.set_transform(prop.offset)
	shape.set_shape(prop.shape)

func bind_array(index, size):
	if index < 0:
		index = size
	elif index > size:
		index = 0
	return index
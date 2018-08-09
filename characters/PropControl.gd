extends Node

var player
var body
var shape
var current_prop = 0
var prop

func _ready():
	player = $".."
	player.connect("prop_changed", self, '_on_Player_prop_changed')
	
	body = get_node(str(player.get_path()) + "/Pivot/Body")
	shape = get_node(str(player.get_path()) + "/Shape")
	
	set_process(false)

func _on_Player_prop_changed(prop_control):
	current_prop = bind_array(current_prop + prop_control, PlayerProps.props.size())
	
	if current_prop == 0:
		prop = PlayerProps.skins[current_prop]
		body.set_texture(load(PlayerProps.skins[player.player_skin].sprite_path))
		body.set_transform(PlayerProps.skins[player.player_skin].offset)
		shape.set_shape(prop.shape)
	else:
		prop = PlayerProps.props[current_prop - 1]
		body.set_texture(load(prop.sprite_path))
		body.set_transform(prop.offset)
		shape.set_shape(prop.shape)		
	
func bind_array(index, size):
	if index < 0:
		index = size
	elif index > size:
		index = 0
	return index
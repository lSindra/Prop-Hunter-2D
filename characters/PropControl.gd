extends Node

const SKINS_PATH = "res://characters/skins/"
const PROP_PATH = "res://characters/props/"
const PROPS = ["body1", "body2"]

var player
var body
var current_prop = 0

func _ready():
	player = $".."
	player.connect("prop_changed", self, '_on_Player_prop_changed')
	
	body = get_node(str(player.get_path()) + "/Pivot/Body")
	
	set_process(false)

func _on_Player_prop_changed(prop):
	current_prop = bind_array(current_prop + prop, PROPS.size())
	
	if current_prop == 0:
		body.set_texture(load(SKINS_PATH + player.player_skin + ".png"))
	else:
		body.set_texture(load(PROP_PATH + PROPS[current_prop - 1] + ".png"))
	
func bind_array(index, size):
	if index < 0:
		index = size
	elif index > size:
		index = 0
	return index
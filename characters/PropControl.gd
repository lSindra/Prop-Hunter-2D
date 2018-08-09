extends Node

const SKINS_PATH = "res://characters/skins/"
const PROP_PATH = "res://characters/props/"
const PROPS = [ ["body1", -61], ["body2", -61], ["rock", -10]]

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
		body.set_texture(load(SKINS_PATH + player.player_skin[0] + ".png"))
		body.set_transform(Transform2D(0.0, Vector2(0, player.player_skin[1])))
	else:
		body.set_texture(load(PROP_PATH + PROPS[current_prop - 1][0] + ".png"))
		body.set_transform(Transform2D(0.0, Vector2(0, PROPS[current_prop - 1][1])))
	
func bind_array(index, size):
	if index < 0:
		index = size
	elif index > size:
		index = 0
	return index
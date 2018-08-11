extends Node

signal change_prop
signal use_skin

var player
var ray_cast
var current_prop = 0
var prop

func _ready():
	player = $".."
	player.connect("prop_changed", self, '_on_Player_prop_changed')
	player.connect("prop_choose", self, '_on_Player_prop_choose')
	
	ray_cast = $"../RayCast2D"
	ray_cast.connect("prop_choose", self, '_on_Player_prop_choose')

	set_process(false)

func _on_Player_prop_choose(prop_id):
	prop = PlayerProps.props[prop_id]
	emit_signal('change_prop', prop)
	current_prop = prop_id + 1

func _on_Player_prop_changed(prop_control):
	current_prop = bind_array(current_prop + prop_control, PlayerProps.props.size())
	
	if current_prop == 0:
		emit_signal('use_skin')
	else:
		prop = PlayerProps.props[current_prop - 1]
		emit_signal('change_prop', prop)

func bind_array(index, size):
	if index < 0:
		index = size
	elif index > size:
		index = 0
	return index
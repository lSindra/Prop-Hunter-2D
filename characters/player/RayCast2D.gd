extends RayCast2D

var player
var mouse_pos
var collider

signal prop_choose

func _ready():
	player = $".."
	player.connect("mirror_prop", self, '_on_Player_mirror_prop')
	
func _physics_process(delta):
	cast_to = player.get_local_mouse_position()
	
	if is_colliding():
		collider = get_collider()
	else:
		collider = null
	
func _on_Player_mirror_prop():
	if collider != null:
		var sprite = get_node(str(collider.get_path()) + "/Sprite")
		var sprite_path = sprite.get_texture().get_path()
		emit_signal('prop_choose', PlayerProps.search_by_sprite_path(sprite_path))
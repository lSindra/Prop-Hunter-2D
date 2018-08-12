extends RayCast2D

var player
var mouse_pos
var line

var detected_sprite

signal prop_choose

func _ready():
	player = $".."
	player.connect("mirror_prop", self, '_on_Player_mirror_prop')
	line = $Line2D
	
func _physics_process(delta):
	cast_to = player.get_local_mouse_position().clamped(150.0)
	
	line.points[1] = player.get_local_mouse_position().clamped(150.0)
	
	if is_colliding():
		var collider = get_collider()
		detected_sprite = get_node(str(collider.get_path()) + "/Sprite")
		detected_sprite.set_material(load("res://characters/shaders/aura_shader.tres"))
	else:
		if detected_sprite != null:
			detected_sprite.set_material(null)
			detected_sprite = null
	
func _on_Player_mirror_prop():
	if detected_sprite != null:
		var sprite_path = detected_sprite.get_texture().get_path()
		emit_signal('prop_choose', PlayerProps.search_by_sprite_path(sprite_path))
extends RayCast2D

var player
var mouse_pos
var did_mouse_move
var last_time_mouse_moved = 0
var line

var detected_sprite
var aura_shader

var timer

signal prop_choose

func _ready():
	player = $".."
	player.connect("mirror_prop", self, '_on_Player_mirror_prop')
	line = $Line2D
	
	timer = Timer.new()
	timer.set_wait_time(2)
	timer.set_one_shot(true)
	timer.connect("timeout", self, "_on_Timeout_clear_aim")
	add_child(timer)
	
	_on_Timeout_clear_aim()
	
	aura_shader = load("res://characters/shaders/aura_shader.tres")

func _input(event):
	if event is InputEventMouseMotion:
		if event.speed.length() > 15:
			timer.start()
			did_mouse_move = true
			mouse_pos = player.get_local_mouse_position()
			cast_to = mouse_pos.clamped(150.0)
			line.points[1] = mouse_pos.clamped(150.0)

func _physics_process(delta):
	if is_colliding():
		var collider = get_collider()
		detected_sprite = get_node(str(collider.get_path()) + "/Sprite")
		detected_sprite.set_material(aura_shader)
	else:
		clear_sprite()

func _on_Timeout_clear_aim():
	did_mouse_move = false
	cast_to = Vector2(0, 0)
	line.points[1] = Vector2(0, 0)
	clear_sprite()

func clear_sprite():
	if detected_sprite != null:
		detected_sprite.set_material(null)
		detected_sprite = null

func _on_Player_mirror_prop():
	if detected_sprite != null:
		var sprite_path = detected_sprite.get_texture().get_path()
		emit_signal('prop_choose', PlayerProps.search_by_sprite_path(sprite_path))
extends KinematicBody2D

var input_direction = Vector2()
var look_direction = Vector2()
var last_move_direction = Vector2(1, 0)

enum STATES { IDLE, RUNNING }
var state = null

var current_animation = []
var current_frame = 0
var last_anim_update = 0
var anim_update_speed = 10

const TICK_TIME = 16
const MAX_WALK_SPEED = 450
const MAX_RUN_SPEED = 700

var speed = 0
var max_speed = 0

var motion = Vector2()
var player_skin
var is_using_skin = true
var body
var shape
var prop_control

func _ready():
	body = $"Pivot/Body"
	shape = $Shape
	prop_control=$PropControl
	
	prop_control.connect("change_prop", self, '_on_Control_change_prop')
	prop_control.connect("use_skin", self, '_on_Control_use_skin')

func _physics_process(delta):
	if input_direction:
		last_move_direction = input_direction
	if input_direction:
		if speed != max_speed:
			speed = max_speed
	else:
		speed = 0

	var velocity = input_direction.normalized() * speed
	move_and_slide(velocity, Vector2(), 5, 2)
	
	if last_anim_update < OS.get_ticks_msec() - TICK_TIME * anim_update_speed:
		animate()
		
func animate():
	last_anim_update = OS.get_ticks_msec()
	if is_using_skin:
		var mouse_loc = get_local_mouse_position()
		if mouse_loc.x < 0:
			body.flip_h = true
		elif mouse_loc.x > 0:
			body.flip_h = false
		if input_direction == Vector2(0,0):
			if state != IDLE: 
				state = IDLE
				load_animation(state)
		else:
			if state != RUNNING: 
				state = RUNNING
				load_animation(state)
		next_frame_by_anim()

func load_animation(animation):
	current_animation = []
	var frames
	match animation:
		IDLE:
			frames = PlayerProps.skins[player_skin].idle_anim
		RUNNING:
			frames = PlayerProps.skins[player_skin].running_anim
	for frame in frames:
		current_animation.append(load(frame))
	last_anim_update = 0

func next_frame_by_anim():
	current_frame = (current_frame + 1) % current_animation.size()
	body.set_texture(current_animation[current_frame])

func set_body(prop):
	if not prop is load("res://characters/helpers/PropModel/Skin.gd"):
		body.set_texture(load(prop.sprite_path))
	else:
		body.set_texture(StreamTexture.new())
	body.set_transform(prop.offset)
	body.set_scale(prop.scale)
	shape.set_shape(prop.shape)
	$"Pivot/Shadow".set_visible(is_using_skin)

func _on_Control_change_prop(prop):
	is_using_skin = false
	set_body(prop)

func _on_Control_use_skin():
	is_using_skin = true
	var skin = PlayerProps.skins[player_skin]
	set_body(skin)
	anim_update_speed = skin.update_speed

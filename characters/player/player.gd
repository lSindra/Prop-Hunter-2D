extends "res://characters/character.gd"

signal prop_changed
signal prop_choose
signal mirror_prop

var prop_control

func _ready():
	player_skin = 0
	
	prop_control=$PropControl
	
	prop_control.connect("change_prop", self, '_on_Control_change_prop')
	prop_control.connect("use_skin", self, '_on_Control_use_skin')

func _input(event):
	if event.is_action_pressed("attack") and attack_state != ATTACK:
		_change_state(ATTACK)
	elif event.is_action_pressed("mirror_prop"):
		emit_signal('mirror_prop')
	elif event.is_action_pressed("prop_choose"):
		emit_signal('prop_choose')
	elif event.is_action_pressed("next_prop"):
		emit_signal('prop_changed', 1)
		
	elif event.is_action_pressed("prev_prop"):
		emit_signal('prop_changed', -1)

func _physics_process(delta):
	input_direction = Vector2()
	input_direction.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	input_direction.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	
	# Running
	max_speed = MAX_RUN_SPEED if Input.is_action_pressed("run") else MAX_WALK_SPEED

func _on_Control_change_prop(prop):
	is_using_skin = false
	body.flip_h = false
	set_body(prop)

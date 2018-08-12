extends "res://characters/character.gd"

signal prop_changed
signal prop_choose
signal mirror_prop

func _ready():
	player_skin = 0

func _physics_process(delta):
	input_direction = Vector2()
	input_direction.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	input_direction.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	
	# Running
	max_speed = MAX_RUN_SPEED if Input.is_action_pressed("run") else MAX_WALK_SPEED
	
	# Choose prop
	if Input.is_action_just_pressed("mirror_prop"):
		emit_signal('mirror_prop')
	elif Input.is_action_just_pressed("prop_choose"):
		emit_signal('prop_choose')
	# Change prop
	elif Input.is_action_just_pressed("next_prop"):
		emit_signal('prop_changed', 1)
		
	elif Input.is_action_just_pressed("prev_prop"):
		emit_signal('prop_changed', -1)
	
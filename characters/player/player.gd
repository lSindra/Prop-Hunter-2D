extends "res://characters/character.gd"

signal direction_changed
signal prop_changed

var player_skin

func _ready():
	player_skin = "body"

func _physics_process(delta):
	input_direction = Vector2()
	input_direction.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	input_direction.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))

	emit_signal('direction_changed', input_direction)
	
	# Running
	max_speed = MAX_RUN_SPEED if Input.is_action_pressed("run") else MAX_WALK_SPEED
	
	# Change prop
	if Input.is_action_just_pressed("next_prop"):
		emit_signal('prop_changed', 1)
		
	if Input.is_action_just_pressed("prev_prop"):
		emit_signal('prop_changed', -1)
#	

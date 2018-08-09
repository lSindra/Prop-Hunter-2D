extends KinematicBody2D

# For visualization
signal speed_updated
signal state_changed

var input_direction = Vector2()
var look_direction = Vector2()
var last_move_direction = Vector2(1, 0)

const MAX_WALK_SPEED = 450
const MAX_RUN_SPEED = 700

var speed = 0
var max_speed = 0

var motion = Vector2()
var player_skin

func _physics_process(delta):
	if input_direction:
		last_move_direction = input_direction
	if input_direction:
		if speed != max_speed:
			speed = max_speed
	else:
		speed = 0
	emit_signal('speed_updated', speed)

	var velocity = input_direction.normalized() * speed
	move_and_slide(velocity, Vector2(), 5, 2)
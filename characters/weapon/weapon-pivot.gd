extends Position2D

var player
var mouse_pos = Vector2(0, 0)

func _ready():
	player = $".."

func _input(event):
	if event is InputEventMouseButton:
		mouse_pos = player.get_local_mouse_position()
			
		rotation = position.angle_to(mouse_pos) - 1.6

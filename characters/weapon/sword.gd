extends Area2D

signal attack_finished

enum STATES { IDLE, ATTACK }
var state = null

enum ATTACK_INPUT_STATES { IDLE, LISTENING, REGISTERED }
var attack_input_state = IDLE
var ready_for_next_attack = false

var hit_objects = []


func _ready():
	$AnimationPlayer.connect('animation_finished', self, "_on_animation_finished")
	self.connect("body_entered", self, "_on_body_entered")
	_change_atack_state(IDLE)


func _change_atack_state(new_state):
	match state:
		ATTACK:
			hit_objects = []
			attack_input_state = IDLE
			ready_for_next_attack = false

	match new_state:
		IDLE:
			$AnimationPlayer.play('idle')
			$AnimationPlayer.stop()
			$sword.visible = false
			monitoring = false
		ATTACK:
			$sword.visible = true
			$AnimationPlayer.play('attack_straight')
			monitoring = true
	state = new_state


func _input(event):
	if not state == ATTACK:
		return
	if attack_input_state != LISTENING:
		return
	if event.is_action_pressed('attack'):
		attack_input_state = REGISTERED


func _physics_process(delta):
	if attack_input_state == REGISTERED and ready_for_next_attack:
		attack()

func attack():
	_change_atack_state(ATTACK)

# use with AnimationPlayer func track
func set_attack_input_listening():
	attack_input_state = LISTENING


# use with AnimationPlayer func track
func set_ready_for_next_attack():
	ready_for_next_attack = true


func _on_body_entered(body):
	if body.get_rid().get_id() in hit_objects:
		return
	hit_objects.append(body.get_rid().get_id())
	body.take_damage(self, 15)


func _on_animation_finished(name):
	print("finished")
	_change_atack_state(IDLE)
	set_attack_input_listening()
	set_ready_for_next_attack()
	emit_signal("attack_finished")

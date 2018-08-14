extends KinematicBody2D

signal state_changed
signal direction_changed

enum STATES { IDLE, ATTACK, STAGGER, DIE, DEAD }
var state = null

# MOTION
var input_direction = Vector2()
var look_direction = Vector2(1, 0)
var last_move_direction = Vector2(1, 0)

# STAGGER
var knockback_direction = Vector2(0.0, 0.0)
export(float) var stagger_knockback = 15
const STAGGER_DURATION = 0.4

# WEAPON
var weapon_path = "res://characters/weapon/Sword.tscn"
var weapon = null


func _ready():
	_change_state(IDLE)
	$AnimationPlayer.connect('animation_finished', self, '_on_AnimationPlayer_animation_finished')
	$Health.connect('health_changed', self, '_on_Health_health_changed')

	if not weapon_path:
		return
	var weapon_instance = load(weapon_path).instance()
	$WeaponPivot/WeaponSpawn.add_child(weapon_instance)
	weapon = $WeaponPivot/WeaponSpawn.get_child(0)
	weapon.connect("attack_finished", self, "_on_Weapon_attack_finished")


func _change_state(new_state):
	match state:
		DIE:
			queue_free()
		ATTACK:
			set_physics_process(true)

	# Initialize the new state
	match new_state:
		IDLE:
			$AnimationPlayer.play('idle')
		ATTACK:
			set_physics_process(false)
			if not weapon:
				print("%s tries to attack but has no weapon" % get_name())
				_change_state(IDLE)
				return

			weapon.attack()
			$AnimationPlayer.play('idle')
		STAGGER:
			$Tween.interpolate_property(self, 'position', position, position + stagger_knockback * -knockback_direction, STAGGER_DURATION, Tween.TRANS_QUAD, Tween.EASE_OUT)
			$Tween.start()

			$AnimationPlayer.play('stagger')
		DIE:
			set_process_input(false)
			set_physics_process(false)
			$CollisionShape2D.disabled = true
			$Tween.stop(self, '')
			$AnimationPlayer.play('die')
	state = new_state
	emit_signal('state_changed', new_state)


func _physics_process(delta):
	if not input_direction:
		return

	last_move_direction = input_direction
	if input_direction.x in [-1, 1]:
		look_direction.x = input_direction.x
		$BodyPivot.set_scale(Vector2(look_direction.x, 1))


func take_damage(attacker_weapon, amount):
	if self.is_a_parent_of(attacker_weapon):
		return
	knockback_direction = (attacker_weapon.global_position - global_position).normalized()
	$Health.take_damage(amount)


func _on_Weapon_attack_finished():
	_change_state(IDLE)


func _on_AnimationPlayer_animation_finished(name):
	if name == 'die':
		_change_state(DEAD)


func _on_Health_health_changed(new_health):
	if new_health == 0:
		_change_state(DIE)
	else:
		_change_state(STAGGER)

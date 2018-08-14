extends KinematicBody2D

signal state_changed

enum STATES { IDLE, RUNNING, DIE }
var state = null
enum ATTACK_STATES { IDLE, ATTACK, STAGGER }
var attack_state = null

# MOTION
const MAX_WALK_SPEED = 450
const MAX_RUN_SPEED = 700
var motion = Vector2()
var input_direction = Vector2()
var look_direction = Vector2()
var last_move_direction = Vector2(1, 0)
var speed = 0
var max_speed = 0

# STAGGER
var knockback_direction = Vector2(0.0, 0.0)
export(float) var stagger_knockback = 15
const STAGGER_DURATION = 0.4

# WEAPON
var weapon_path = "res://characters/weapon/Sword.tscn"
var weapon = null

# ANIMATION
var current_animation = []
var current_frame = 0
var last_anim_update = 0
var anim_update_speed = 10

const TICK_TIME = 16

# SHADER
var player_skin
var is_using_skin = true
var body
var shape

func _ready():
	body = $"Pivot/Body"
	shape = $Shape
	
	
	$AnimationPlayer.connect('animation_finished', self, '_on_AnimationPlayer_animation_finished')
	$Health.connect('health_changed', self, '_on_Health_health_changed')

	if not weapon_path:
		return
	var weapon_instance = load(weapon_path).instance()
	$WeaponPivot/WeaponSpawn.add_child(weapon_instance)
	weapon = $WeaponPivot/WeaponSpawn.get_child(0)
	weapon.connect("attack_finished", self, "_on_Weapon_attack_finished")

func _change_state(new_state):
	match attack_state:
		DIE:
			queue_free()
		ATTACK:
			set_physics_process(true)

	match new_state:
		IDLE:
			pass
		ATTACK:
			if not weapon:
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
	attack_state = new_state
	emit_signal('state_changed', new_state)


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
	if current_animation.size() > 0:
		current_frame = (current_frame + 1) % current_animation.size()
	else:
		return
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

func _on_Control_use_skin():
	is_using_skin = true
	var skin = PlayerProps.skins[player_skin]
	set_body(skin)
	anim_update_speed = skin.update_speed

func _on_Weapon_attack_finished():
	_change_state(IDLE)
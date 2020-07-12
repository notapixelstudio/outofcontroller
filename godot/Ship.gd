extends RigidBody2D

class_name Ship

var aim = 0.0
var dying = false setget set_dying
var type setget set_type

func set_dying(v):
	dying = v
	if dying:
		$DyingSFX.play()
		$Sprite/AnimationPlayer.play("dying")
	else:
		$DyingSFX.stop()
		$Sprite/AnimationPlayer.play("default")

func set_type(v):
	type = v
	$Sprite.texture = load('res://assets/'+type+'ship.png')

const stats = {
	'north': {
		'speed': {'x': 50, 'y': 40},
		'bullet_lifetime': 1.0
	},
	'east': {
		'speed': {'x': 55, 'y': 45},
		'bullet_lifetime': 1.0
	},
	'west': {
		'speed': {'x': 40, 'y': 35},
		'bullet_lifetime': 1.25
	},
	'south': {
		'speed': {'x': 70, 'y': 0}
	}
}

func _physics_process(delta):
	var command_x = Input.get_action_strength(type+"ship_right")-Input.get_action_strength(type+"ship_left")
	var command_y = Input.get_action_strength(type+"ship_down")-Input.get_action_strength(type+"ship_up")
	
	apply_central_impulse(Vector2(stats[type]['speed']['x']*command_x, stats[type]['speed']['y']*command_y))
	
	var aim_x = Input.get_action_strength("westship_aim_right")-Input.get_action_strength("westship_aim_left")
	var aim_y = Input.get_action_strength("westship_aim_down")-Input.get_action_strength("westship_aim_up")
	
	if not(aim_x == 0 and aim_y == 0):
		aim = atan2(aim_x,-aim_y) - PI

signal fire
var fire_t = 0

func _process(delta):
	if not dying:
		if type == 'west':
			fire_t += delta
			if fire_t > 0.1:
				fire_t -= 0.1
				fire('continuous')
		
		if type == 'north' and Input.is_action_just_pressed("northship_fire") or type == 'east' and Input.is_action_just_pressed("eastship_fire"):
			fire('normal')
		elif type == 'east' and Input.is_action_just_pressed("eastship_fire_alt"):
			fire('reversed')
	
func fire(mode):
	$FireSFX.stream.loop = false
	$FireSFX.play()
	emit_signal('fire', mode, stats[type]['bullet_lifetime'])

signal damaged
func _on_Ship_body_entered(body):
	if body.is_in_group('harmful'):
		harm(body)
		
func harm(body = null):
	$HarmSFX.stream.loop = false
	$HarmSFX.play()
	emit_signal('damaged')
	if body:
		apply_central_impulse(10*(position-body.position))
		

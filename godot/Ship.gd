extends RigidBody2D

class_name Ship

var aim = 0.0

var type setget set_type

func set_type(v):
	type = v
	$Sprite.texture = load('res://assets/'+type+'ship.png')

const stats = {
	'north': {
		'speed': {'x': 50, 'y': 30},
		'bullet_lifetime': 0.75
	},
	'east': {
		'speed': {'x': 55, 'y': 35},
		'bullet_lifetime': 0.5
	},
	'west': {
		'speed': {'x': 40, 'y': 25},
		'bullet_lifetime': 1.0
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
	if type == 'west':
		fire_t += delta
		if fire_t > 0.1:
			fire_t -= 0.1
			emit_signal('fire', 'continuous', stats[type]['bullet_lifetime'])
	
	if type == 'north' and Input.is_action_just_pressed("northship_fire") or type == 'east' and Input.is_action_just_pressed("eastship_fire"):
		emit_signal('fire', 'normal', stats[type]['bullet_lifetime'])
	elif type == 'east' and Input.is_action_just_pressed("eastship_fire_alt"):
		emit_signal('fire', 'reversed', stats[type]['bullet_lifetime'])
	

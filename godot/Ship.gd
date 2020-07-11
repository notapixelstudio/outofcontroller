extends RigidBody2D

class_name Ship

var type setget set_type

func set_type(v):
	type = v
	$Sprite.texture = load('res://assets/'+type+'ship.png')

const stats = {
	'north': {
		'speed': {'x': 50, 'y': 30}
	},
	'east': {
		'speed': {'x': 55, 'y': 35}
	},
	'west': {
		'speed': {'x': 40, 'y': 25}
	},
	'south': {
		'speed': {'x': 55, 'y': 0}
	}
}

func _physics_process(delta):
	var command_x = Input.get_action_strength(type+"ship_right")-Input.get_action_strength(type+"ship_left")
	var command_y = Input.get_action_strength(type+"ship_down")-Input.get_action_strength(type+"ship_up")
	
	apply_central_impulse(Vector2(stats[type]['speed']['x']*command_x, stats[type]['speed']['y']*command_y))
	

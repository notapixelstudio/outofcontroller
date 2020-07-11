extends RigidBody2D

const SPEED_X = 50
const SPEED_Y = 30

func _physics_process(delta):
	var command_x = Input.get_action_strength("northship_right")-Input.get_action_strength("northship_left")
	var command_y = Input.get_action_strength("northship_down")-Input.get_action_strength("northship_up")
	
	apply_central_impulse(Vector2(SPEED_X*command_x, SPEED_Y*command_y))
	

extends RigidBody2D

signal shoot

var life = 5
var target = null

func _ready():
	reset()

func reset():
	$Timer.stop()
	$Timer.start(0.3+0.5*randf())
	
func _on_Timer_timeout():
	reset()
	emit_signal('shoot')
	
signal score

func harm(body):
	life -= 1
	if life <= 0:
		emit_signal('score', 500, position)
		queue_free()
		
func _process(delta):
	if target:
		rotation = (position-target.position).angle()

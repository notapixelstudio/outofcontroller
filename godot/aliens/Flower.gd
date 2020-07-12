extends RigidBody2D

signal shoot

var life = 3
var target = null

func _ready():
	reset()

func reset():
	$Timer.stop()
	$Timer.start(0.3+0.5*randf())
	
func _on_Timer_timeout():
	reset()
	emit_signal('shoot')
	
func harm(body):
	life -= 1
	if life <= 0:
		queue_free()
		
func _process(delta):
	if target:
		rotation = (position-target.position).angle()

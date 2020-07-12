extends RigidBody2D

signal shoot

var life = 3

func _ready():
	reset()

func reset():
	$Timer.stop()
	$Timer.start(0.2+1.5*randf())
	
func _on_Timer_timeout():
	reset()
	emit_signal('shoot')
	
signal score

func harm(body):
	life -= 1
	if life <= 0:
		emit_signal('score', 100, position)
		queue_free()
		

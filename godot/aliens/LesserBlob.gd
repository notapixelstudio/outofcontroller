extends RigidBody2D

signal score

func harm(body):
	emit_signal('score', 25, position)
	queue_free()
	

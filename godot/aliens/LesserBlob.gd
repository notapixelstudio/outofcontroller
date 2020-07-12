extends RigidBody2D

signal dead

func harm(body):
	emit_signal('dead', 25, position)
	queue_free()
	

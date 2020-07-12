extends RigidBody2D

signal picked

func _on_PickupArea_body_entered(body):
	if body is Ship:
		emit_signal('picked', self)
		queue_free()

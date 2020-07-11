extends RigidBody2D


var lifetime = -1 setget set_lifetime

func set_lifetime(v):
	lifetime = v
	$Timer.start(lifetime)

func _on_Timer_timeout():
	queue_free()
	
func _on_Bullet_body_entered(body):
	queue_free()
	

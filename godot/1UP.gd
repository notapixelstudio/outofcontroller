extends RigidBody2D

var type setget set_type

func set_type(v):
	type = v
	$Sprite.texture = load('res://assets/'+type+'ship.png')
	
	
signal picked

func _on_PickupArea_body_entered(body):
	if body is Ship:
		emit_signal('picked', type)
		queue_free()

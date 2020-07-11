extends Node2D

var Bullet = preload('res://Bullet.tscn')

func _ready():
	set_ship_type('north')
	$OneUP.type = 'east'
	
func set_ship_type(type):
	$Ship.type = type
	$Schematics.texture = load('res://assets/'+type+'_controls.png')
	

func _on_1UP_picked(type):
	set_ship_type(type)
	
func _on_DeathWall_body_entered(body):
	body.queue_free()
	
func _on_Ship_fire(mode):
	if mode == 'normal':
		var bullet = Bullet.instance()
		bullet.position = $Ship.position + Vector2(0, -48)
		bullet.linear_velocity = Vector2(0, -500)
		add_child(bullet)
		bullet.lifetime = 0.75
		

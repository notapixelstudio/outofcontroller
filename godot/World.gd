extends Node2D

var Bullet = preload('res://Bullet.tscn')

func _ready():
	set_ship_type('north')
	$OneUP.type = 'west'
	
var t = 0.0
func _process(delta):
	t += delta
	$CanvasLayer/Time.text = str(int(floor(t)))
	
func set_ship_type(type):
	$Ship.type = type
	$CanvasLayer/Schematics.texture = load('res://assets/'+type+'_controls.png')
	

func _on_1UP_picked(type):
	set_ship_type(type)
	
func _on_DeathWall_body_entered(body):
	body.queue_free()
	
func _on_Ship_fire(mode, lifetime):
	var bullet = Bullet.instance()
	add_child(bullet)
	bullet.lifetime = lifetime
	
	if mode == 'normal':
		bullet.position = $Ship.position + Vector2(0, -64)
		bullet.linear_velocity = Vector2(0, -500)
	elif mode == 'reversed':
		bullet.position = $Ship.position + Vector2(0, 64)
		bullet.rotation_degrees = 180
		bullet.linear_velocity = Vector2(0, 500)
	elif mode == 'continuous':
		bullet.position = $Ship.position + Vector2(0, 64).rotated($Ship.aim)
		bullet.rotation = $Ship.aim + PI
		bullet.linear_velocity = Vector2(0, 500).rotated($Ship.aim)


func _on_Ship_damaged():
	$CanvasLayer/LifeCounter.lose_life(1)
	


func _on_LifeCounter_dead():
	$Ship.queue_free()
	
const field_w = 832
const margin = 48

const Blob = preload('res://aliens/Blob.tscn')
func spawn_blob():
	var alien = Blob.instance()
	alien.position = Vector2(margin+randi()%(field_w-margin), -64)
	add_child(alien)
	

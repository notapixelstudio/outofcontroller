extends Node2D

var Bullet = preload('res://Bullet.tscn')

func _ready():
	set_ship_type('north')
	
var t = 0.0
func _process(delta):
	t += delta
	$CanvasLayer/Time.text = str(int(floor(t)))
	
func set_ship_type(type):
	$Ship.type = type
	$CanvasLayer/Schematics.texture = load('res://assets/'+type+'_controls.png')
	

func _on_1UP_picked(type):
	set_ship_type(type)
	$CanvasLayer/LifeCounter.reset()
	$Ship.dying = false
	$DeathTimer.stop()
	
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

const LesserBlob = preload('res://aliens/LesserBlob.tscn')
func _on_Blob_shoot(blob):
	if $Ship and blob:
		var object = LesserBlob.instance()
		object.position = blob.position + 48*($Ship.position-blob.position).normalized()
		add_child(object)
		
const EvilBullet = preload('res://aliens/EvilBullet.tscn')
func _on_Flower_shoot(flower):
	if $Ship and flower:
		var object = EvilBullet.instance()
		object.lifetime = 0.8
		object.position = flower.position + 96*($Ship.position-flower.position).normalized()
		object.linear_velocity = 300*($Ship.position-flower.position).normalized()
		object.rotation = ($Ship.position-flower.position).angle() + PI/2
		add_child(object)

func _on_Ship_damaged():
	$CanvasLayer/LifeCounter.lose_life(1)
	
func _on_LifeCounter_dead():
	$Ship.dying = true
	$DeathTimer.start(5.0)
	
const field_w = 832
const margin = 48

const Blob = preload('res://aliens/Blob.tscn')
func spawn_blob(amount = 1):
	for i in range(amount):
		var alien = Blob.instance()
		alien.position = Vector2(margin+randi()%(field_w-margin), -64)
		add_child(alien)
		alien.connect('shoot', self, '_on_Blob_shoot', [alien])
		
const Flower = preload('res://aliens/Flower.tscn')
func spawn_flower(amount = 1):
	for i in range(amount):
		var alien = Flower.instance()
		alien.position = Vector2(margin+randi()%(field_w-margin), -64)
		alien.target = $Ship
		add_child(alien)
		alien.connect('shoot', self, '_on_Flower_shoot', [alien])
	
const OneUp = preload('res://1UP.tscn')
func spawn_1up(type):
	var object = OneUp.instance()
	object.position = Vector2(margin+randi()%(field_w-margin), -64)
	add_child(object)
	object.type = type
	object.connect('picked', self, '_on_1UP_picked')
	


func _on_DeathTimer_timeout():
	$Ship.queue_free()

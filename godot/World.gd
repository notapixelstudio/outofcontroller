extends Node2D

var Bullet = preload('res://Bullet.tscn')

var score = 0
var unlocked_ships = {
	'north': true
}

func comma_sep(number):
	var string = str(number)
	var mod = string.length() % 3
	var res = ""
	
	for i in range(0, string.length()):
		if i != 0 && i % 3 == mod:
			res += ","
		res += string[i]
	
	return res


var timeformat = "{min}:{sec}"
func sec_to_min(seconds: float) -> String:
	var m = int(floor(seconds/60))
	var s = int(floor(seconds))%60
	var ms = stepify(seconds,0.1) - int(seconds)
	s = s + ms
	var ss: String = "0"+str(s) if s < 10 else str(s)
	if ss.find(".") < 0:
		ss = ss+".0"
	return timeformat.format({"min": m, "sec": ss})

func _ready():
	randomize()
	set_ship_type('north')
	
var t = 0.0
func _process(delta):
	t += delta
	$CanvasLayer/Time.text = sec_to_min(t)
	if $Ship:
		$Ship/Countdown.text = str(int(ceil($DeathTimer.time_left)))
		
	$CanvasLayer/Score.text = comma_sep(score)

func set_ship_type(type):
	$Ship.type = type
	$CanvasLayer/Schematics.texture = load('res://assets/'+type+'_controls.png')
	

func _on_1UP_picked(type):
	set_ship_type(type)
	$OneUPSFX.stream.loop = false
	$OneUPSFX.play()
	$CanvasLayer/LifeCounter.reset()
	$Ship.dying = false
	$Ship/Countdown.visible = false
	$DeathTimer.stop()
	
func _on_Coin_picked(coin):
	add_score(300, coin.position)
	$CoinSFX.stream.loop = false
	$CoinSFX.play()
	
const ScoreFeedback = preload('res://ScoreFeedback.tscn')
func add_score(amount, where):
	score += amount
	
	var object = ScoreFeedback.instance()
	object.position = where
	add_child(object)
	object.score = amount
	
const Squish = preload('res://Squish.tscn')
func alien_dead(amount, where):
	$SblorchSFX.stream.loop = false
	$SblorchSFX.play()
	add_score(amount, where)
	
	var object = Squish.instance()
	add_child(object)
	object.position = where
	
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
		object.connect('dead', self, 'alien_dead')
		
const EvilBullet = preload('res://aliens/EvilBullet.tscn')
func _on_Flower_shoot(flower):
	if $Ship and flower:
		for angle in [-PI/6, 0, PI/6]:
			var object = EvilBullet.instance()
			object.position = flower.position + 96*($Ship.position-flower.position).normalized().rotated(angle)
			object.linear_velocity = 500*($Ship.position-flower.position).normalized().rotated(angle)
			object.rotation = ($Ship.position-flower.position).angle() + PI/2 + angle
			add_child(object)
			object.lifetime = 1.0

func _on_Ship_damaged():
	$CanvasLayer/LifeCounter.lose_life(1)
	
func _on_LifeCounter_dead():
	$Ship.dying = true
	$DeathTimer.start(5.0)
	$Ship/Countdown.visible = true
	
	# give the opportunity to live
	spawn_1up()
	
const field_w = 832
const margin = 96

const Blob = preload('res://aliens/Blob.tscn')
func spawn_blob(amount = 1):
	for i in range(amount):
		var alien = Blob.instance()
		alien.position = Vector2(margin+randi()%(field_w-margin), -64)
		add_child(alien)
		alien.connect('shoot', self, '_on_Blob_shoot', [alien])
		alien.connect('dead', self, 'alien_dead')

const Flower = preload('res://aliens/Flower.tscn')
func spawn_flower(amount = 1):
	for i in range(amount):
		var alien = Flower.instance()
		alien.position = Vector2(margin+randi()%(field_w-margin), -64)
		alien.target = $Ship
		add_child(alien)
		alien.connect('shoot', self, '_on_Flower_shoot', [alien])
		alien.connect('dead', self, 'alien_dead')
	
const OneUp = preload('res://1UP.tscn')
func spawn_1up(type = null):
	if type:
		unlocked_ships[type] = true
	else:
		var types = unlocked_ships.keys()
		type = types[randi()%len(types)]
		while $Ship and len(types) > 1 and $Ship.type == type:
			type = types[randi()%len(types)] # FIXME horrible
	
	var object = OneUp.instance()
	object.position = Vector2(margin+randi()%(field_w-margin), -64)
	add_child(object)
	object.type = type
	object.connect('picked', self, '_on_1UP_picked')
	
const Coin = preload('res://Coin.tscn')
func spawn_coin():
	var object = Coin.instance()
	object.position = Vector2(margin+randi()%(field_w-margin), -64)
	add_child(object)
	object.connect('picked', self, '_on_Coin_picked')

func _on_DeathTimer_timeout():
	if $Ship:
		gameover(score)
		$Ship.queue_free()

func gameover(score):
	set_process(false)
	var g_scene = load("res://GameOver.tscn")
	var gameover = g_scene.instance()
	$CanvasLayer.add_child(gameover)
	gameover.start(1.0)

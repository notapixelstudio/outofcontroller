extends Node2D

var life : int = 3 setget set_life
var max_life : int = 3 setget set_max_life

signal dead
func set_life(amount):
	life = amount
	refresh()
	if life <= 0:
		emit_signal("dead")
	
func set_max_life(amount):
	max_life = amount
	refresh()
	
func refresh():
	$hearts.region_rect = Rect2(Vector2(0,0), Vector2(48*life,96))
	$hearts_empty.region_rect = Rect2(Vector2(0,0), Vector2(48*max_life,96))
	
func lose_life(amount):
	if life <= 0:
		return
		
	set_life(max(0, life - amount))
	
func reset():
	set_life(max_life)
	
func _ready():
	reset()
	

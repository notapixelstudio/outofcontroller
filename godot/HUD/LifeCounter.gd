extends Node2D

var life : int = 3 setget set_life
var max_life : int = 3 setget set_max_life

func set_life(amount):
	life = amount
	refresh()
	
func set_max_life(amount):
	max_life = amount
	refresh()
	
func refresh():
	$hearts.region_rect = Rect2(Vector2(0,0), Vector2(152*life,260))
	$hearts_empty.region_rect = Rect2(Vector2(0,0), Vector2(152*max_life,260))
	
func lose_life(amount):
	set_life(max(0, life - amount))
	
func reset():
	set_life(max_life)
	

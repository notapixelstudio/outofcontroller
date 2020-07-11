extends Node2D

func _ready():
	set_ship_type('north')
	
func set_ship_type(type):
	$Ship.type = type
	$Schematics.texture = load('res://assets/'+type+'_controls.png')
	

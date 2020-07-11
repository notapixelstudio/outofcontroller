extends Node2D

func _ready():
	set_ship_type('north')
	$OneUP.type = 'east'
	
func set_ship_type(type):
	$Ship.type = type
	$Schematics.texture = load('res://assets/'+type+'_controls.png')
	


func _on_1UP_picked(type):
	set_ship_type(type)
	

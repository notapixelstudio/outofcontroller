extends Node

func _ready():
	
	SilentWolf.configure({
		"api_key": "nhEiDdEK5E8PAowwDabV18piLmLK7oIgqOXiFn21",
		"game_id": "outofcontroller",
		"game_version": "1.0.2",
		"log_level": 1
	})
	
	SilentWolf.configure_scores({
		"open_scene_on_close": "res://MainScreen.tscn"
	})

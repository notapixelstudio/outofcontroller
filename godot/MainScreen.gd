extends Control


func _on_Credits_pressed():
	get_tree().change_scene("res://Credits.tscn")

func _on_Leaderboard_pressed():
	get_tree().change_scene("res://Leaderboard.tscn")


func _on_Start_pressed():
	get_tree().change_scene("res://World.tscn")


func _on_Quit_pressed():
	get_tree().quit()

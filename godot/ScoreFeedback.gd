extends Node2D


var score = 100 setget set_score

func set_score(v):
	score = v
	$Wrapper/Countdown.text = str(score)
	

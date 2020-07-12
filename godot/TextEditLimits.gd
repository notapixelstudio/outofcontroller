extends TextEdit
export var LIMIT : int = 15


func _on_Name_text_changed():
	if text.length() > LIMIT:
		readonly = true

func _input(event):
	if event.is_action_pressed("backspace"):
		readonly = false

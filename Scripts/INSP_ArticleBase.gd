extends VBoxContainer

var articleinfo = false

func _on_button_button_up():
	if articleinfo == false:
		$CollapsibleContainer.open_tween()
		articleinfo = true
	else:
		$CollapsibleContainer.close_tween()
		articleinfo = false

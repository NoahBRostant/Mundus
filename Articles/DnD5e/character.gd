extends Control

@export var img:Texture
@export var title:String
@export var saved:bool

var temptitle

func _on_line_edit_text_changed(new_text):
	title = new_text

func _input(event):
	pass

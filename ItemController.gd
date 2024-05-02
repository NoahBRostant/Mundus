extends VBoxContainer

@export var title:String
@export var img:Texture

func _process(delta):
	$Button/HBoxContainer/Label.text = title
	$Button/HBoxContainer/MarginContainer/TextureRect.texture = img

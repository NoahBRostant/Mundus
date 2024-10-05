extends Control

@export var title:String
@export_multiline var description:String
@export var shorthand_img:Texture
@export var banner_img:Texture
@export var filepath:String
@export var core:bool

func _ready() -> void:
	if core != true and $HBoxContainer/MarginContainer2:
		$HBoxContainer/MarginContainer2.hide()
	$HBoxContainer/Label.text = title
	$HBoxContainer/MarginContainer/TextureRect.texture = shorthand_img


func _on_button_pressed():
	Console.articleDefinitions


func _on_buttonarticlenode_pressed():
	$"../../../../../../../..".update_info(title,description,banner_img)
	var siblings = get_parent().get_children()
	for i in siblings:
		if i != self:
			i.button_pressed = false

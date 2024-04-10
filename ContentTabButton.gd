extends Button

@export var img:Texture
@export var title:String

func _ready():
	var siblings = get_parent().get_children()
	for i in siblings:
		i.button_pressed = false
	siblings[0].button_pressed = true

func _process(delta):
	$MarginContainer/HBoxContainer/VBoxContainer/RichTextLabel.text = title
	$MarginContainer/HBoxContainer/VBoxContainer2/TextureRect.texture = img
	pass


func _on_pressed():
	var siblings = get_parent().get_children()
	for i in siblings:
		i.button_pressed = false
	self.button_pressed = true
